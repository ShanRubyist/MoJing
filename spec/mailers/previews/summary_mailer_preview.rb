# Preview all emails at http://localhost:3000/rails/mailers/summary_mailer/

class SummaryMailerPreview < ActionMailer::Preview
  def weekly_notify
    SummaryMailer.weekly_notify
  end

  def monthly_notify
    SummaryMailer.monthly_notify
  end
end
