#!/bin/bash

api="https://temp-number.org/api/v1"
idtk_api="https://www.googleapis.com/identitytoolkit/v3/relyingparty"
idtk_api_key="AIzaSyAlcJQ9-p4CwtRAp03qQG5I5zAjKU-1Hwc"
user_id=null
id_token=null
auth_token=null

function login() {
	response=$(curl --request POST \
		--url "$idtk_api/verifyPassword?key=$idtk_api_key" \
		--user-agent "Dalvik/2.1.0 (Linux; U; Android 9; RMX3551 Build/PQ3A.190705.003)" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"email": "'$1'",
			"password": "'$2'",
			"returnSecureToken": "true"
		}')
	if [ -n $(jq -r ".idToken" <<< "$response") ]; then
		user_id=$(jq -r ".localId" <<< "$response")
		id_token=$(jq -r ".idToken" <<< "$response")
	fi
	echo $response
}

function register() {
	curl --request POST \
		--url "$idtk_api/signupNewUser?key=$idtk_api_key" \
		--user-agent "Dalvik/2.1.0 (Linux; U; Android 9; RMX3551 Build/PQ3A.190705.003)" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"email": "'$1'",
			"password": "'$2'"
		}'
}

function get_oob_confirmation_code() {
	curl --request POST \
		--url "$idtk_api/getOobConfirmationCode?key=$idtk_api_key" \
		--user-agent "Dalvik/2.1.0 (Linux; U; Android 9; RMX3551 Build/PQ3A.190705.003)" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"requestType": "4",
			"idToken": "'$1'",
			"androidInstallApp": false,
			"canHandleCodeInApp": false,
			"androidPackageName": "com.receive.sms_second.number",
			"dynamicLinkDomain": "tempnumber.page.link"
		}'
}

function get_account_info() {
	curl --request POST \
		--url "$idtk_api/getAccountInfo?key=$idtk_api_key" \
		--user-agent "Dalvik/2.1.0 (Linux; U; Android 9; RMX3551 Build/PQ3A.190705.003)" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{"idToken": "'$id_token'"}'
}

function get_balance() {
	curl --request GET \
		--url "$api/user/balance" \
		--user-agent "okhttp/4.9.0" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $id_token"
}


function get_active_activations_count() {
	curl --request GET \
		--url "$api/activations/active" \
		--user-agent "okhttp/4.9.0" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $id_token"
}

function get_activations() {
	curl --request GET \
		--url "$api/activations/active?page=$1&limit=$2" \
		--user-agent "okhttp/4.9.0" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $id_token"
}

function get_transactions() {
	curl --request GET \
		--url "$api/user/transactions?page=$1&limit=$2" \
		--user-agent "okhttp/4.9.0" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $id_token"
}

function get_popular_services() {
	curl --request GET \
		--url "$api/services/popular" \
		--user-agent "okhttp/4.9.0" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_countries() {
	curl --request GET \
		--url "$api/countries" \
		--user-agent "okhttp/4.9.0" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function change_password() {
	curl --request POST \
		--url "$idtk_api/setAccountInfo?key=$idtk_api_key" \
		--user-agent "UnityPlayer/2021.3.16f1 (UnityWebRequest/1.0, libcurl/7.84.0-DEV)" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "x-unity-version: 2021.3.16f1" \
		--data '{
			"returnSecureToken": "true",
			"idToken": "'$id_token'",
			"password": "'$1'"
		}'
}

function delete_account() {
	curl --request DELETE \
		--url "$api/user" \
		--user-agent "okhttp/4.9.0" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}
