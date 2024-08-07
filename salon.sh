#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"

# Function to display the services menu with correct format
DISPLAY_SERVICES() {
  echo -e "\n1) Trim"
  echo -e "2) Cut"
  echo -e "3) Color"
  echo -e "4) Exit"
}

# Function to get customer info
GET_CUSTOMER_INFO() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # If customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]; then
    echo -e "\nIt looks like you are a new customer. What's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # Get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
}

# Function to handle user selection
MAIN_MENU() {
  local VALID_OPTION=false

  while [ "$VALID_OPTION" = false ]; do
    DISPLAY_SERVICES

    echo -e "\nPlease enter the service_id of the service you would like:"
    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in
      1|2|3)
        VALID_OPTION=true
        GET_CUSTOMER_INFO
        echo -e "\nWhat time would you like your service, $CUSTOMER_NAME?"
        read SERVICE_TIME
        INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
        SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
        ;;
      4) EXIT; VALID_OPTION=true ;;
      *) echo "Please enter a valid option." ;;
    esac
  done
}

MAIN_MENU
