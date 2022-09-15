ZONE_ID="Z005396725ZQYS9AQ6CZX"
SG_NAME="allow-all"
ENV="dev"
#############################

create_ec2() {
  PRIVATE_IP=$(aws ec2 run-instances \
      --image-id ${AMI_ID} \
      --instance-type t2.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
      --security-group-ids ${SGID} \
      --iam-instance-profile Name=SecretManager_Role_for_RoboShop_Nodes \
      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

}

#AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
AMI_ID=ami-0bb6af715826253bf
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')

if [ -z "$1" ]; then
  echo "Input the node name"
  exit 1
else
  COMPONENT=$1
  create_ec2
fi