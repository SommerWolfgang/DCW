table 6086208 "CDC CDN Participation"
{
    Caption = 'Participation';

    fields
    {
        field(1; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
            TableRelation = "CDC CDN Network";
        }
        field(2; "Identifier Type ID"; Integer)
        {
            Caption = 'Identifier Type ID';
            TableRelation = "CDC CDN Participant ID Type"."Network Name" where("Network Name" = field("Network Name"));
        }
        field(3; "Identifier Value"; Text[50])
        {
            Caption = 'Identifier Value';
        }
        field(10; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
        }
        field(11; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(12; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(13; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(14; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
        }
        field(15; "Your Name"; Text[100])
        {
            Caption = 'Your Name';
        }
        field(16; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
        }
        field(17; "Contact Phone No."; Text[30])
        {
            Caption = 'Contact Phone No.';
        }
        field(18; "Contact Email"; Text[80])
        {
            Caption = 'Contact Email';
        }
        field(19; "Publish in Registry"; Boolean)
        {
            Caption = 'Publish data in Registry';
        }
        field(20; "Registration Status"; Option)
        {
            Caption = 'Registration Status';
            OptionCaption = 'Draft,In process,Connected,Rejected';
            OptionMembers = Draft,InProcess,Connected,Rejected;
        }
    }

    keys
    {
        key(Key1; "Network Name", "Identifier Type ID", "Identifier Value")
        {
            Clustered = true;
        }
    }
}