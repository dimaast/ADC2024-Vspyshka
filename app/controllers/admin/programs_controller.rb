class Admin::ProgramsController < ApplicationController
  load_and_authorize_resource
  before_action :set_program, only: %i[ show edit update destroy ]

  def index
    @programs = Program.all
  end

  def show
  end

  def new
    @program = Program.new
  end

  def edit
  end

  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to admin_program_path(@program), notice: "Program was successfully created." }
        format.json { render :show, status: :created, location: @program }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to admin_program_path(@program), notice: "Program was successfully updated." }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @program.destroy!

    respond_to do |format|
      format.html { redirect_to admin_programs_path, status: :see_other, notice: "Program was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_program
      @program = Program.find(params[:id])
    end

    def program_params
      params.require(:program).permit(:name, :faculty_id)
    end
end