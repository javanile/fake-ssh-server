
build:
	chmod +x entrypoint.sh
	docker build -t javanile/fake-ssh-server .

push: build
	docker push javanile/fake-ssh-server

destroy:
	docker stop fake-ssh-server
	docker rm -f fake-ssh-server

run: build destroy
	docker run --name fake-ssh-server -p 22:22 -v $(PWD):/fake-ssh-server -d javanile/fake-ssh-server

test: run
	ssh -oStrictHostKeyChecking=no ubuntu@localhost ls /fake-ssh-server
