INSTANCE_NAME=win-2016-openssh-vm
ZONE=us-central1-a

gcloud compute instances create $INSTANCE_NAME \
  --scopes storage-ro,default \
  --zone=$ZONE \
  --machine-type=n1-standard-2 \
  --metadata-from-file windows-startup-script-ps1=install_openssh.ps1 \
  --image=windows-server-2016-dc-v20191112 \
  --image-project=windows-cloud \
  --boot-disk-size=200GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=$INSTANCE_NAME

