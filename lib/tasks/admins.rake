namespace :admins do

  desc "Create first admin"
  task :create_admin => :environment do
    AdminUser.create(name: "Admin ContigoMujer", 
                  email: "admin@contigomujer.com", 
                  superadmin: true,
                  password: "contigo123", 
                  password_confirmation: "contigo123")
  end

end
