hostname = node[:hostname]

script "Install monit daemon" do
  interpreter "bash"
  user "root"
  code <<-EOH
  aptitude install -y monit
  EOH
end

template "/etc/default/monit" do
  source "monit.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/monit/conf.d/main.conf" do
  source "main.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    :hostname => hostname
  })
end

template "/etc/monit/conf.d/unicorn.conf" do
  source "unicorn.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    :hostname => hostname
  })
end

template "/etc/monit/conf.d/delayed_job.conf" do
  source "delayed_job.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    :hostname => hostname
  })

  only_if "test -e /etc/init.d/delayed_job"
end

script "Start monit daemon" do
  interpreter "bash"
  user "root"
  code <<-EOH
  /etc/init.d/monit restart
  EOH
end

