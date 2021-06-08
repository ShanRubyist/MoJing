class ProbeSettingsController < ApplicationController
  def create
    @probe_setting = ProbeSetting.new(probe_setting_params)
    @probe_setting.users = [current_user]

    respond_to do |format|
      if @probe_setting.save
        format.html { redirect_to probe_settings_path, notice: 'probe_setting was successfully created.' }
        format.js { redirect_to probe_settings_path, notice: 'probe_setting was successfully created.' }
        # format.json { render :show, status: :created, location: @probe_setting }
        format.json { render json: { message: 'Created Success' } }

      else
        format.html { render :new }
        format.js { render :new }
        format.json { render json: @probe_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    probe_setting = ProbeSetting.find(params[:id])
    probe_setting.destroy
    render json: { message: '删除成功'}
  end

  private

  def probe_setting_params
    params[:probe_setting][:user_id] = current_user.id
    params.require(:probe_setting).permit(:url, :port, :retry_limit, :proxy, :status, :user_id)
  end
end
