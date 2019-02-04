#!/bin/bash
# Author: Brian Peterson
# Date: 02/01/2019

REGEX_PRACTICE='regex_practice.txt'

PHONE_NUMBER_REGEX='^[0-9]{3}-[0-9]{3}-[0-9]{4}$'
PHONE_NUMBER_303_REGEX='^303-.*'
EMAIL_REGEX='^[a-zA-Z][a-zA-Z]{1,63}@[a-zA-Z]{1,63}\.{1,63}'
EMAIL_GEOCITIES_REGEX='@geocities.com'

COMMAND_OUTPUT_FILE='command_results.txt'
PHONE_OUTPUT_FILE='phone_results.txt'
EMAIL_OUTPUT_FILE='email_results.txt'

GIT_AUTO_COMMITS_BEGIN_TAG='begin-auto-commits'
GIT_REPO_NAME='lab_2_3308'

# 1. Accept a regular expression & file name from the user with a prompt
echo "What regex would you like to scan for in regex_practice.txt?"
read regex
echo "Great. And what file would you like your regex result put into?"
read user_outfile

# 2. Feed the user's regular expression into grep and run into the user's chosen file.
user_regex_results=$(egrep $regex $REGEX_PRACTICE)
echo -e "User regex results: \n$user_regex_results" > $user_outfile

# 3. Hardcode some grep command calls which will...
# 3.1. Count the number of phone numbers in regex_practice.txt
echo "Got your results. Now, looking at phone numbers in regex_practice.txt..."
phone_numbers=$(egrep $PHONE_NUMBER_REGEX $REGEX_PRACTICE) 
num_phone_numbers=$(echo $phone_numbers | wc -w)
echo "Your file has $num_phone_numbers phone numbers in it." > $PHONE_OUTPUT_FILE

# 3.2. Count the number of emails in regex_practice.txt
echo "Now looking at email addresses..."
num_emails=$(egrep $EMAIL_REGEX $REGEX_PRACTICE -c)
echo "Your file has $num_emails email addresses in it." > $EMAIL_OUTPUT_FILE

# 3.3 List all of the phone numbers in the "303" area code and store the results in "phone_results.txt". 
# Technical Note: It's important to pass the results from grep to echo in double quotes--otherwise bash abuses the newlines 
echo "Checking for phone numbers that start with 303..."
phone_numbers_303=$(echo "$phone_numbers" | egrep "$PHONE_NUMBER_303_REGEX")
num_phone_numbers_303=$(echo "$phone_numbers_303" | wc -l)
echo -e "All phone numbers beginning with '303', $num_phone_numbers in total: \n$phone_numbers_303" >> $PHONE_OUTPUT_FILE

# 3.4. List all of the emails from geocities.com and store the results in "email_results.txt"
echo "Checking for email addresses at the geocities.com domain..."
geocities_emails=$(egrep $EMAIL_GEOCITIES_REGEX $REGEX_PRACTICE)
echo "$geocities_emails" >> $EMAIL_OUTPUT_FILE

# 3.5. List all of the lines that match a command-line regular expresion and store the results in "command_results.txt"
echo "What's one more regex to scan for in practice_regex.txt?"
read second_regex
egrep $second_regex $REGEX_PRACTICE > $COMMAND_OUTPUT_FILE 
echo "Output of just this last regex search were put in $COMMAND_OUTPUT_FILE"
echo "Finally, let's store the results from this script run. Press enter to save everything to git (except your first regex command, for whatever reason). " 
# 4. Run git add on your updated text files (phone_results, email_results, command_results). Only these files should be staged!
git add $PHONE_OUTPUT_FILE
git add $EMAIL_OUTPUT_FILE
git add $COMMAND_OUTPUT_FILE

# 5. Run git commit, with a default message
# Get the number, in the project history, of the commit we're about to make
let git_current_results_number=$(git rev-list --count $GIT_AUTO_COMMITS_BEGIN_TAG..)+1
echo "Committing results run #$git_current_results_number"
git commit -m "New grep regex results #$git_current_results_number -- phone, email, & user-provided regex result"

# 6. Optionally, you can have your script also push your changes to Github.
echo "Pushing these results to github!"
git push "https://$git_username:$git_password@github.com/$git_username/$GIT_REPO_NAME"
