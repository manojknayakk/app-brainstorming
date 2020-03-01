class NotesController < ApplicationController
  before_action :set_note, only: [:show, :update, :destroy]

  # GET /notes
  def index
    notes_accesses = @current_user.notes_accesses.includes(:note)
    msg = []
    notes_accesses.each do |notes_access|
      msg.push({
        id: notes_access.note.id,
        title: notes_access.note.title,
        description: notes_access.note.content,
        is_editable: notes_access.role_id != Role.find_by_role_name("reader").id ? true : false,
        is_owner: notes_access.role_id == Role.find_by_role_name("owner").id ? true : false
      })
    end
    render json: msg
  end

  # GET /get_roles
  def get_roles
    roles = Role.where.not(:role_name => "owner")
    msg = []
    roles.each do |role|
      msg.push(
        value: role.id,
        label: role.role_name.titlecase
      )
    end
    render json: msg
  end

  # GET /notes/1
  def show
    notes_access = NotesAccess.where(:note_id => @note.id, :user_id => @current_user.id).first
    if !notes_access.blank?
      is_owner = notes_access.role_id == Role.find_by_role_name("owner").id ? true : false
      is_editable = notes_access.role_id == Role.find_by_role_name("contributer").id ? true : false
      msg = {
        id: @note.id,
        title: @note.title,
        description: @note.content,
        is_owner: is_owner,
        is_editable: is_editable,
        users: []
      }
      if is_owner
        notes_accesses = @note.notes_accesses.includes(:user, :role)
        notes_accesses.each do |notes_access|
          next if notes_access.user.id == @current_user.id
          msg[:users].push({
            id: notes_access.id,
            _destroy: false,
            email: {
              id: notes_access.user.id,
              email: notes_access.user.email
            }, 
            role: {
              value: notes_access.role_id,
              label: notes_access.role.role_name.titlecase
            }
          })
        end
      end
      render json: msg
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # POST /notes
  def create
    @note = Note.new(note_params)

    if @note.save
      NotesAccess.create!(:note_id => @note.id, :user_id => @current_user.id, :role_id => Role.find_by_role_name("owner").id)
      render json: @note, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    notes_access = NotesAccess.where(:note_id => @note.id, :user_id => @current_user.id).first
    if !notes_access.blank? && notes_access.role_id == Role.find_by_role_name("owner").id
      @note.destroy
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:title, :content, notes_accesses_attributes: [:id, :role_id, :user_id, :_destroy])
    end
end
