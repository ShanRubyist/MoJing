desc 'project update'
task :update => ['update:git_pull', 'update:bundle', 'update:migrate', 'update:whenever']

namespace :update do
  desc 'git pull'
  task :git_pull do
    cmd = 'git pull'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc '安装依赖包'
  task :bundle do
    cmd = 'sudo bundle'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc '执行数据库迁移'
  task :migrate do
    cmd = 'rails db:migrate'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end

  desc '设定 config/schedule 定时任务'
  task :whenever do
    cmd = 'whenever --update-cron'
    puts "[*] #{cmd}"
    Kernel.system cmd
  end
end
