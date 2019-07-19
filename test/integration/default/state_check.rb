describe command('terraform state list') do
  its('stdout') { should include "module.dc1-nomad_server.aws_instance.new_instance" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.dc1-nomad_client.aws_instance.new_instance" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.dc2-nomad_server.aws_instance.new_instance" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.dc2-nomad_client.aws_instance.new_instance" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.nomad_frontend.aws_instance.nginx_instance" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.nomad_frontend.cloudflare_record.nomad_frontend" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform state list') do
  its('stdout') { should include "module.nomad_frontend.null_resource.certbot" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end