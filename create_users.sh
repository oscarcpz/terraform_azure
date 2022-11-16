#!/bin/bash

USERSFILE=users.list

# extracting usernames from the file one-by-one
username=$(cat $USERSFILE | tr 'A-Z'  'a-z') # tr cambia de mayusculas a minusculas
echo $username

# running loop  to add users
for user in $username
do
       # adding users '$user' is a variable that changes usernames accordingly in txt file.
       useradd -m $user
       # defining the default password
       password=$user@123
       echo "$user:$password" | chpasswd
       echo $user:$password
done

# echo is used to display the total numbers of users created, counting the names in the txt file,
# tail to display the final details of the process on both lines(optional)
echo "$(wc -l $USERSFILE) users have been created"
tail -n$(wc -l $USERSFILE) /etc/passwd