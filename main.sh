#!/bin/bash

Time=$(date "+%Y-%m-%d-%H-%M-%S")

# Function to save output to a file
function save_output {
    local data="$1"
    local file_name="$2"
    echo "$data" > "${Time}_${file_name}"
    echo "List of $3 saved to ${Time}_${file_name}"
}

# Function to list S3 buckets
function list_s3_buckets {
    local buckets=$(aws s3 ls | awk '{print $3}')
    save_output "$buckets" "s3_buckets.txt" "S3 buckets"
}

# Function to list EC2 instances
function list_ec2_instances {
    local instance_ids=$(aws ec2 describe-instances | jq -r '.Reservations[].Instances[].InstanceId')
    save_output "$instance_ids" "ec2_instances.txt" "EC2 instances"
}

# Function to list Lambda functions
function list_lambda_functions {
    local function_names=$(aws lambda list-functions | jq -r '.Functions[].FunctionName')
    save_output "$function_names" "lambda_functions.txt" "Lambda functions"
}

# Function to list RDS instances
function list_rds_instances {
    local rds_instances=$(aws rds describe-db-instances | jq -r '.DBInstances[].DBInstanceIdentifier')
    save_output "$rds_instances" "rds_instances.txt" "RDS instances"
}

# Function to list IAM users
function list_iam_users {
    local iam_users=$(aws iam list-users | jq -r '.Users[].UserName')
    save_output "$iam_users" "iam_users.txt" "IAM users"
}

# Function to display the menu and get user's choice
function display_menu {
    echo "Select the resource type you want to list:"
    echo "1. S3 Buckets"
    echo "2. EC2 Instances"
    echo "3. Lambda Functions"
    echo "4. RDS Instances"
    echo "5. IAM Users"
    echo "6. Exit"
    read -p "Enter your choice (1-6): " choice
}

# Execution
display_menu

while [ "$choice" != "6" ]; do
    case $choice in
        1) list_s3_buckets ;;
        2) list_ec2_instances ;;
        3) list_lambda_functions ;;
        4) list_rds_instances ;;
        5) list_iam_users ;;
        *)
            echo "Invalid choice. Please select again."
            ;;
    esac

    display_menu
done

echo "Script execution completed."
