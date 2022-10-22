# open mail_addresses_from_mbox.txt, parse emails out, deduplicate emails, and write to a CSV with the collumns "email" and "name"
import re
import csv

with open('mail_addresses_from_mbox.txt', 'r') as file:
    emails = file.read()
    emails = re.findall('(.*)<(.*)>', emails)
    emails = sorted(list(set(emails)))
    emails = [[x[1], x[0]] for x in emails]

check_list = ['noreply', 'no-reply']

with open('emails.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['email', 'name'])
    for email in emails:
        if any(substring in email[0] for substring in check_list):
            continue
        writer.writerow([email[0], email[1].replace('"', '').strip()])