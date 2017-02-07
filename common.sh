checkCFStatus(){
	## Timeout for checking the status of a new stack
	local statusTimeout=1000
	local statusStart=0
	local stackname=$1
	local profile=""	# optional variable

	if [[ ! -z "$2" ]]; then
		profile="--profile $2"
	fi

    ## Check the return code of a CloudFormation stack and identify whether an actual status check is needed.
    if [ "$RC" -eq 0 ]; then
        echo "[INFO] CloudFormation was successfully executed, continuing to collect status."
    elif [ "$RC" -ne 0 ] && [ $(grep 'No updates are to be performed' ${WORKSPACE}/CFstderr.log > /dev/null 2>&1; echo $?) -eq 0 ]; then
    	echo "[INFO] No CloudFormation update-stack needed."
        return
    else
        echo "[ERRO] CloudFormation Failed, exiting."
        exit 1
    fi

    ## Check the status of a CloudFormation stack to ensure a failure of a stack create/update will display the failure reason and exit the pipeline creation.
    while [ ${statusStart} -le ${statusTimeout} ]; do
        CFStatus=$(aws ${profile} cloudformation describe-stacks --stack-name ${stackname} | grep "\"StackStatus\":")
        if [[ "${CFStatus}" == *"CREATE_COMPLETE"* ]];then
                echo "[INFO] CloudFormation Completed Successfully."
                return
        elif [[ "${CFStatus}" == *"UPDATE_COMPLETE"* ]];then
                echo "[INFO] CloudFormation Completed Successfully."
                return
        elif [[ "${CFStatus}" == *"ROLLBACK_COMPLETE"* ]];then
                echo "[ERRO] An error occurred when running the CloudFormation Stack. Displaying the CloudFormation Stack Events."
                aws ${profile} cloudformation describe-stack-events --stack-name ${stackname} --query 'StackEvents[?ResourceStatus==`CREATE_FAILED`].ResourceStatusReason' --output text
                echo "[ERRO] CloudFormation Failed, exiting."
                exit 1
        fi

        statusStart=$(echo ${statusStart} + 10 |bc)
        echo "[INFO] Checking again in 10 seconds."
        sleep 10
    done

    echo "[WARN] CheckCFStatus Timeout was reached exiting..."
    exit 1
}