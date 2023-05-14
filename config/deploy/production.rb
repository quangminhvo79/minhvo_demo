role :app, %w{ubuntu@ec2-3-27-161-41.ap-southeast-2.compute.amazonaws.com}
role :web, %w{ubuntu@ec2-3-27-161-41.ap-southeast-2.compute.amazonaws.com}
role :db,  %w{ubuntu@ec2-3-27-161-41.ap-southeast-2.compute.amazonaws.com}

server 'ec2-3-27-161-41.ap-southeast-2.compute.amazonaws.com', user: 'ubuntu', roles: %w{web app db}

set :stage,  :production
set :branch, 'develop'

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey password],
  keys: %w[~/MinhVoAWS.pem]
}
