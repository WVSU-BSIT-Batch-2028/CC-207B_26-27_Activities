from pathlib import Path
import json
from reportlab.pdfgen import canvas
from reportlab.lib.colors import HexColor
from reportlab.lib.utils import ImageReader
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import Paragraph
from reportlab.lib.enums import TA_LEFT
from PIL import Image

ROOT = Path(__file__).resolve().parent
OUT = ROOT.parent / 'output/pdf/James_Remegio_Unit_5_Screenshot_Evidence.pdf'
items = [
('01_loading','Loading organizations','The loading indicator appears while a repository request is pending. TODOs 1-2.'),
('02_organization_list','Organization list','A successful request displays all eight organizations in the phone-width layout. TODO 1.'),
('03_error_retry','Error feedback','Server: error displays a helpful connection message and the Try again action. TODO 4.'),
('04_retry_loading','Retry starts another request','Pressing Try again returns the screen to loading. With error mode unchanged, it returns to the error state. TODO 2; E3.'),
('05_empty_refresh','Empty repository result','Server: empty displays the empty-state message and Refresh action. TODO 5.'),
('06_search_match','Search filters the list','Typing robotics leaves CICT Robotics Club as the only matching organization. TODO 6; E4.'),
('07_search_no_results','Search with no matches','An unmatched query displays a distinct no-results message. TODO 6.'),
('08_favorite','Long-press favorite','Long-pressing CICT Robotics Club fills its star. The parent screen stores the favorite state. TODO 3; E6.'),
('09_swipe_hide_undo','Swipe to hide','Swiping Computer Science Circle removes its card and displays CSC hidden with UNDO. TODO 7.'),
('10_undo_restored','Undo restores the card','Pressing UNDO restores Computer Science Circle; the Robotics favorite remains selected. TODO 7.'),
('11_org_detail','Details and missing banner','Opening Robotics shows its description, member count, Join button, and placeholder for its null banner URL. E8.'),
('12_form_initial_disabled','Initial form state','The untouched form has no validation errors. Submit is disabled while the agreement is unchecked. TODO 14; E11.'),
('13_form_validation','Validation and digits only','Invalid submission shows name, school-email, ID-length and year-level errors. Typing 12ab3 leaves only 123. TODOs 9, 11-12.'),
('14_form_reset','Reset clears the form','Reset clears values and validation errors and restores Events, 3 hours, updates on, and an unchecked agreement.'),
('15_form_valid_enabled','Valid form and changed inputs','Demo data is entered; Year 2, Media, 7 hours and updates off are selected. Checking the agreement enables Submit. TODOs 11-14.'),
('16_registration_success','Registration returned to list','Submitting valid data returns to the list, displays Welcome to CRC, James Remegio! and marks Robotics as Joined. TODOs 9-10; E7, E9.'),
('17_already_member_disabled','Duplicate joining disabled','Reopening the joined organization displays a disabled Already a member button. TODO 8.'),
('18_responsive_grid','Responsive grid layout','At a 1200-pixel viewport width, the same screen displays three columns. The joined state is retained. E5.'),
('19_network_banner','Network banner loaded','Computer Science Circle displays its downloaded banner image and organization details. E8.'),
('20_banner_error_fallback','Failed-image fallback','The ITSO image request was deliberately blocked in the browser. The app displays its broken-image placeholder and remains usable. E8.'),
]
D={x[0]:x for x in items}
(ROOT/'manifest.json').write_text(json.dumps([dict(file=f'screenshots/{a}.png',title=b,description=c) for a,b,c in items],indent=2)+'\n')
W,H=595.276,841.89
c=canvas.Canvas(str(OUT),pagesize=(W,H))
c.setTitle('James Remegio - Unit 5 Screenshot Evidence')
c.setAuthor('James Remegio')
style=ParagraphStyle('caption',fontName='Helvetica',fontSize=9,leading=12,textColor=HexColor('#334A4A'))
def para(text,x,y,width):
 p=Paragraph(text,style);_,h=p.wrap(width,200);p.drawOn(c,x,y-h);return h

def page_header(number,title):
 c.setFillColor(HexColor('#006B62'));c.rect(0,H-7,W,7,fill=1,stroke=0)
 c.setFont('Helvetica',9);c.drawString(36,H-30,'CC 207B  /  UNIT 5  /  APPLICATION EVIDENCE')
 c.setFillColor(HexColor('#152C2B'));c.setFont('Helvetica-Bold',18);c.drawString(36,H-56,title)
 c.setFillColor(HexColor('#54706D'));c.setFont('Helvetica',9);c.drawString(36,H-74,'James Remegio  |  Captured 14 October 2026')
 c.setStrokeColor(HexColor('#D2DFDB'));c.line(36,37,W-36,37)
 c.setFont('Helvetica',8);c.drawString(36,24,'Actual Flutter web screenshots | Chrome | Demo registration data')
 c.drawRightString(W-36,24,f'{number} / 11')

def shot(key,x,top,width,maxheight=598):
 file,title,desc=D[key];p=ROOT/'screenshots'/f'{file}.png';im=Image.open(p)
 h=width*im.height/im.width
 if h>maxheight:width*=maxheight/h;h=maxheight
 c.setFont('Helvetica-Bold',10);c.setFillColor(HexColor('#006B62'));c.drawString(x,top,f'{file[:2]}  {title}')
 c.drawImage(ImageReader(im),x,top-12-h,width=width,height=h)
 c.setStrokeColor(HexColor('#DAE5E2'));c.rect(x,top-12-h,width,h,stroke=1,fill=0)
 para(desc,x,top-22-h,249)

pages=[
('Loading and successful content','01_loading','02_organization_list'),
('Error handling and retry','03_error_retry','04_retry_loading'),
('Empty content and no search results','05_empty_refresh','07_search_no_results'),
('Search and favorites','06_search_match','08_favorite'),
('Swipe dismissal and recovery','09_swipe_hide_undo','10_undo_restored'),
('Organization details and banners','11_org_detail','19_network_banner'),
('Form affordance and validation','12_form_initial_disabled','13_form_validation'),
('Reset and completed form','14_form_reset','15_form_valid_enabled'),
('Successful registration','16_registration_success','17_already_member_disabled'),
]
for n,(title,left,right) in enumerate(pages,1):
 page_header(n,title);shot(left,36,H-105,249);shot(right,310,H-105,249);c.showPage()
page_header(10,'Image failure recovery')
shot('20_banner_error_fallback',36,H-105,249)
para('<b>Controlled failure experiment</b><br/><br/>The browser blocked only the ITSO banner request. The application source and repository data were unchanged. The visible broken-image icon is the result of OrgBanner.errorBuilder.<br/><br/>The remaining organization details and Join action remain available.<br/><br/><b>Banner coverage</b><br/>Screenshot 11: missing URL placeholder.<br/>Screenshot 19: successful image download.<br/>Screenshot 20: failed download placeholder.',310,H-105,249)
c.showPage()
page_header(11,'Responsive layout and verification')
shot('18_responsive_grid',36,H-105,W-72,maxheight=350)
para('<b>Verification results</b><br/>flutter test: 7 tests passed.<br/>flutter analyze: No issues found.<br/>flutter build web: Completed successfully.<br/><br/><b>Capture environment</b><br/>Flutter 3.35.6 / Dart 3.9.2; Chrome 154. Portrait screenshots use a 430 x 1050 viewport; the grid uses 1200 x 800. PNGs were captured at 2x pixel density. These are web viewport captures, not Android emulator screenshots.<br/><br/><b>Project continuity</b><br/>The Desktop project was used because the earlier /workspace path is unavailable. The SDK constraint was adjusted to ^3.9.2 and dependencies resolved. Application Dart files were unchanged. A temporary copy with a standard Flutter web launcher was built because the original launcher file was unavailable locally in iCloud.<br/><br/>The email address and student ID are sample test values. Original PNGs, captions and test logs accompany this PDF.',36,310,W-72)
c.showPage();c.save();print(OUT)
