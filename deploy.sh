# The script is intended for jenkins to deploy opene_repo backend artifacts into test environment docker container.
openeid=`docker inspect -f '{{.Id}}' opene`
repoupdates=/var/lib/docker/aufs/mnt/$openeid/tmp/opene_updates/opene_repo
cp addo-webapp*.war $repoupdates
cp *.amp $repoupdates
cp ../alfresco-googledocs-repo-3.0.2.amp $repoupdates
docker exec opene bash /tmp/opene_updates/opene_repo/update_repo.sh
