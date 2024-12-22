#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"
SERVICES=("cut" "color" "perm" "style" "trim")

echo -e "\n~~ My Salon ~~"

echo "Welcome to My Salon, how can I help you?"
echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"

read SERVICE_ID_SELECTED
while [[ $SERVICE_ID_SELECTED > 5 || $SERVICE_ID_SELECTED < 1 ]]
do
  echo -e "I could not find that service. Please try again. 1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED
done

echo $SERVICE_ID_SELECTED

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_PHONE_INPUT=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_PHONE_INPUT ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  echo -e "\nWhat time would you like your ${SERVICES[$SERVICE_ID_SELECTED-1]}, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "\nI have put you down for a ${SERVICES[$SERVICE_ID_SELECTED-1]} at $SERVICE_TIME, $CUSTOMER_NAME."

  CUSTOMER_INFO_INPUT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' AND name='$CUSTOMER_NAME'")
  
  CUSTOMER_APPOINTMENT_INPUT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
else
  CUSTOMER_NAME="${CUSTOMER_PHONE_INPUT## }"
  echo -e "\nWhat time would you like your ${SERVICES[$SERVICE_ID_SELECTED-1]}, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "\nI have put you down for a ${SERVICES[$SERVICE_ID_SELECTED-1]} at $SERVICE_TIME, $CUSTOMER_NAME."
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' AND name='$CUSTOMER_NAME'")
  
  CUSTOMER_APPOINTMENT_INPUT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
fi
