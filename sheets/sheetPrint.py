import gspread
#import csv
from oauth2client.service_account import ServiceAccountCredentials

#For the json file you'll need to share the client email provided with desired sheet file you want to edit
#scope for spreadsheets and for drive
scope = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive' ]
credentials = ServiceAccountCredentials.from_json_keyfile_name('spreadsheet-example-240602-3df61217e12e.json', scope)

gc = gspread.authorize(credentials)

wks = gc.open('SuaCode Test').sheet1

#print(wks.get_all_records())

#wks.append_row(['First Name','Last Name','Other Name', 'Met Deadline','Submitted','Original Total Score','Converted Score','Criteria Missed','Resubmitted' ])
wks.append_row(['First Name','Last Name','Group Name', 'Grade','Error 1', 'Error 2', 'Error 3', 'Error 4', 'Error 5']);
