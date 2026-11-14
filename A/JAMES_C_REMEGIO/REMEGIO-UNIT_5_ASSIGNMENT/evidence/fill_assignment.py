from pathlib import Path
from io import BytesIO
import copy,json
from pypdf import PdfReader,PdfWriter
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Paragraph
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.utils import ImageReader
from PIL import Image
from xml.sax.saxutils import escape
ROOT=Path('/Users/jamesremegio/Desktop/assignment_org_fair_completed')
SRC=Path('/Users/jamesremegio/Desktop/James Remegio - Unit 5 Assignment.pdf')
OUT=ROOT/'output/pdf/REMEGIO-UNIT_5_ASSIGNMENT.pdf'
pdfmetrics.registerFont(TTFont('Arial','/System/Library/Fonts/Supplemental/Arial.ttf'))
pdfmetrics.registerFont(TTFont('ArialBold','/System/Library/Fonts/Supplemental/Arial Bold.ttf'))
W,H=612,792
r=PdfReader(SRC);w=PdfWriter()
fit=[]
def overlay(draw):
 b=BytesIO();c=canvas.Canvas(b,pagesize=(W,H));draw(c);c.save();b.seek(0);return PdfReader(b).pages[0]
def text(c,s,x,top,size=10,font='Arial'):
 c.setFont(font,size);c.setFillColorRGB(0,0,0);c.drawString(x,H-top-size,s)
def cell(c,s,x,t,width,height,size=8.2):
 size0=size
 while True:
  st=ParagraphStyle('cell',fontName='Arial',fontSize=size,leading=size*1.06,splitLongWords=True)
  p=Paragraph(escape(s),st);_,ph=p.wrap(width-6,height)
  if ph<=height-2.0:break
  size-=.1
  if size<6.6:raise ValueError((s,ph,height))
 p.drawOn(c,x+3,H-t-(height-ph)/2-ph);fit.append((s,size))
def p1(c):
 text(c,'James C. Remegio',115,131,12)
 text(c,'10/14/2026',466,133,10)
 text(c,'BSIT 3A',176,157,12)
a=copy.deepcopy(r.pages[0]);a.merge_page(overlay(p1));w.add_page(a)
w.add_page(r.pages[1])
entries={x['file'].split('/')[-1].replace('.png',''):x for x in json.loads((ROOT/'evidence/manifest.json').read_text())}
pairs=[['01_loading','02_organization_list'],['03_error_retry','04_retry_loading'],['05_empty_refresh','07_search_no_results'],['06_search_match','08_favorite'],['09_swipe_hide_undo','10_undo_restored'],['11_org_detail','19_network_banner'],['12_form_initial_disabled','13_form_validation'],['14_form_reset','15_form_valid_enabled'],['16_registration_success','17_already_member_disabled'],['20_banner_error_fallback'],['18_responsive_grid']]
def evidence(c,keys,n):
 text(c,f'James C. Remegio | BSIT 3A | Evidence {n} of {len(pairs)}',72,135,9)
 if keys==['18_responsive_grid']:
  e=entries[keys[0]];im=Image.open(ROOT/'evidence'/e['file']);ww=468;hh=ww*im.height/im.width
  text(c,'18. Responsive grid layout',72,160,10,'ArialBold');c.drawImage(ImageReader(im),72,H-181-hh,width=ww,height=hh)
  desc=e['description']+' Captured in Chrome at 1200 x 800; portrait views use 430 x 1050. Registration values are sample test data.'
  p=Paragraph(escape(desc),ParagraphStyle('d',fontName='Arial',fontSize=10,leading=13));_,ph=p.wrap(468,200);p.drawOn(c,72,H-195-hh-ph)
  text(c,'Verification: all 7 Flutter tests passed; flutter analyze found no issues.',72,570,10)
  text(c,'Additional code experiments (performed on a temporary copy):',72,600,10,'ArialBold')
  experiments='E5: Removing Expanded produced "Vertical viewport was given unbounded height." Restoring Expanded resolved the layout error.<br/><br/>E11: onUserInteraction showed no initial errors and validated after editing. Switching to always showed required-field errors immediately.<br/><br/>The submitted source retains Expanded and onUserInteraction.'
  p=Paragraph(experiments,ParagraphStyle('experiments',fontName='Arial',fontSize=10,leading=14));_,ph=p.wrap(468,150);p.drawOn(c,72,H-620-ph)
  return
 for i,key in enumerate(keys):
  e=entries[key];im=Image.open(ROOT/'evidence'/e['file']);x=72+i*242;ww=226;hh=ww*im.height/im.width
  text(c,f"{key[:2]}. {e['title']}",x,158,9,'ArialBold')
  c.drawImage(ImageReader(im),x,H-178-hh,width=ww,height=hh)
  p=Paragraph(escape(e['description']),ParagraphStyle('caption',fontName='Arial',fontSize=8,leading=10))
  _,ph=p.wrap(226,100);p.drawOn(c,x,H-185-hh-ph)
 if len(keys)==1:
  msg='The ITSO banner request was deliberately blocked in the browser to test the errorBuilder. The application displayed its broken-image placeholder and remained usable. No application code or repository data was changed for this capture.'
  p=Paragraph(escape(msg),ParagraphStyle('note',fontName='Arial',fontSize=10,leading=14));_,ph=p.wrap(226,300);p.drawOn(c,314,H-190-ph)
for n,keys in enumerate(pairs,1):
 a=PdfReader(SRC).pages[2];a.merge_page(overlay(lambda c,k=keys,n=n:evidence(c,k,n)));w.add_page(a)
answers=[
'OrgFairApp has no changing local state. OrgListScreen owns the future, query, favorites and registrations, which rebuild through setState().',
'Dispose releases controller listeners/resources, preventing leaks when the screen is removed.',
'Error -> loading -> error again. Try again replaces the future; error mode keeps failing until the mode changes.',
'onChanged saves _query in setState(); rebuilding filters the list with the new query.',
'Expanded bounds the viewport height; without it, height is unbounded. Constraints go down; sizes go up.',
'The parent owns _favoriteIds; setState rebuilds OrgCard with the updated isFavorite value.',
'pop(registration) completes the push() future; the detail passes it to the list to save.',
'A null URL shows a placeholder. loadingBuilder shows progress, then the image; errorBuilder shows a broken-image icon on failure.',
'The screen may be removed during await; mounted guards using an invalid context.',
'GlobalKey<FormState> accesses this FormState: validate() checks fields, save() runs onSaved, and reset() restores initial values.',
'onUserInteraction validates after input or on submit, avoiding initial errors. always validates even untouched fields from the start.'
]
bounds=[187.306,215.518,231.874,260.086,276.443,292.799,309.155,325.511,353.723,370.079,398.291,426.503]
rows=[
('OrgListScreen; ListView.builder / GridView.builder','Stateful screen: owns future, search and sets; setState rebuilds the list/grid.'),
('OrgCard; Icon','Stateless card/icon: favorite state belongs to the parent and is passed in.'),
('OrgBanner; Image.network','OrgBanner is stateless; Image is stateful and handles asynchronous loading.'),
('FilledButton; JoinFormScreen','FilledButton and form are stateful; form agreement controls whether Submit is enabled.')]
def p4(c):
 for i,s in enumerate(answers):cell(c,s,379.475,bounds[i],177.9,bounds[i+1]-bounds[i])
 ys=[515.346,534.337,553.328,572.319,591.31]
 for i,(widgets,why) in enumerate(rows):
  cell(c,widgets,187.2,ys[i],158.4,ys[i+1]-ys[i],8)
  cell(c,why,345.6,ys[i],194.4,ys[i+1]-ys[i],8)
a=copy.deepcopy(r.pages[3]);a.merge_page(overlay(p4));w.add_page(a)
w.add_metadata({'/Title':'James C. Remegio - Unit 5 Assignment','/Author':'James C. Remegio'})
with open(OUT,'wb') as f:w.write(f)
print(OUT);print('Pages:',len(w.pages));print('Smallest answer font:',min(v for _,v in fit))
