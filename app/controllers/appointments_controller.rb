class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments
  # GET /appointments.json
  def index
    self.custom_cancan(['Receptionist','Customer'])

    if current_user.type == "Receptionist"
      @appointments = Appointment.joins(:user, :pet).select("
        users.name as userName,
        pets.name as petName,
        appointments.user_id,
        appointments.id,
        appointments.date,
        appointments.reminder,
        appointments.reason
      ")
    else
      @appointments = Appointment.joins(:user, :pet).select("
        users.name as userName,
        pets.name as petName,
        appointments.user_id,
        appointments.id,
        appointments.date,
        appointments.reminder,
        appointments.reason
      ").where("appointments.user_id" => current_user.id)
    end
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    self.custom_cancan(['Receptionist'])

    @appointment = Appointment.new
    @pets = Pet.select("id,name").where(:user_id => params[:user_id])
  end

  # GET /appointments/1/edit
  def edit
    self.custom_cancan(['Receptionist'])
    self.custom_cancan_id

    @customers = User.select("id,name").where(:type => "Customer")
    @pets = Pet.select("id,name").where(:user_id => params[:user_id])
  end

  # POST /appointments
  # POST /appointments.json
  def create
    self.custom_cancan(['Receptionist'])

    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'Appointment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @appointment }
      else
        format.html { render action: 'new' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    self.custom_cancan(['Receptionist'])

    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to @appointment, notice: 'Appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    self.custom_cancan(['Receptionist'])

    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params[:appointment]
    end
end
