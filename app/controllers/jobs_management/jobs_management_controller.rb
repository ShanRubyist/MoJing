# frozen_string_literal: true
# require 'sidekiq/api'

module JobsManagement
  class JobsManagementController < ::ApplicationController
    include RunningJosbsCountable

    def running_jobs_count
      authorize User, :valid_user?

      respond_to do |format|
        format.json do
          render json: {
              running_rss_jobs_count: running_rss_jobs_count,
              running_goods_jobs_count: running_goods_jobs_count
          }
        end
      end
    end

    def start_all_job
      job_class = case params['type']
                  when 'WebSpiderWorkJob'
                    # WebSpiderWorkJob
                  else
                    RssWorkJob
                  end

      ProbeSetting.where(user_id: current_user.id).each do |setting|
        job_class.perform_later(setting)
      end

      render(json: {message: '任务启动成功!'})
    rescue
      render(json: nil, status: 502)
    end

    def start_job
      setting = nil

      job_class = case params['type']
                  when 'RssWorkJob'
                    setting = ProbeSetting.find(params['id'])
                    RssWorkJob
                  when 'WebSpiderWorkJob'
                    setting = PddWebSpiderSetting.find(params['id'])
                    WebSpiderWorkJob
                  end

      # job_class = params['type'].constantize

      rst = job_class.perform_later(setting)
      rst ? render(json: {message: '任务启动成功!'}) : render(json: nil, status: 502)
    end

    def delete_job
      job = Sidekiq::Queue.new.find_job(params['jid'])

      begin
        job.delete
        render json: {message: '任务停止成功!'}
      rescue => e
        render json: nil, status: 502
      end
    end
  end
end