table 12032506 "Email Distribution Setup"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland

    Caption = 'Email Distribution Setup';

    fields
    {
        field(1; "Email Distribution Code"; Code[10])
        {
            Caption = 'Email Distribution Code';
            NotBlank = true;
            TableRelation = "Email Distribution Code";
        }
        field(5; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            Description = '';
        }
        field(6; "Use for Type"; Option)
        {
            Caption = 'Use for Type';
            Description = '';
            OptionCaption = ' ,Customer,Vendor,Contact,Responsibility Center';
            OptionMembers = " ",Customer,Vendor,Contact,"Responsibility Center";
        }
        field(7; "Use for Code"; Code[20])
        {
            Caption = 'Use for Code';
            Description = '';
        }
        field(10; Description; Text[30])
        {
            CalcFormula = lookup("Email Distribution Code".Description where(Code = field("Email Distribution Code")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Mail Type"; Option)
        {
            Caption = 'Mail Type';
            OptionCaption = 'Outlook,SMTP';
            OptionMembers = Outlook,SMTP;
        }
        field(30; Sender; Option)
        {
            Caption = 'Sender';
            OptionCaption = 'Current User,Fixed';
            OptionMembers = "Current User","Fixed";

        }
        field(40; "Sender Address"; Text[80])
        {
            Caption = 'Sender Address';
            ExtendedDatatype = EMail;
        }
        field(50; "Sender Name"; Text[80])
        {
            Caption = 'Sender Name';
        }
        field(60; "Recipient Type"; Option)
        {
            Caption = 'Recipient Type';
            OptionCaption = 'Automatic,Fixed';
            OptionMembers = Automatic,"Fixed";
        }
        field(70; "Recipient Address"; Text[80])
        {
            Caption = 'Recipient Address';
            ExtendedDatatype = EMail;
        }
        field(80; "Cc Recipients"; Text[250])
        {
            Caption = 'Cc Recipients';
            ExtendedDatatype = EMail;
        }
        field(90; "Subject Line Format"; Option)
        {
            Caption = 'Subject Line Format';
            OptionCaption = 'Recipient Name - Source Type - Source No.,Company Name - Source Type - Source No.,Subject Text';
            OptionMembers = "Recipient Name - Source Type - Source No.","Company Name - Source Type - Source No.","Subject Text";
        }
        field(100; "Hide Mail Dialog"; Boolean)
        {
            Caption = 'Suppress Email Dialog';
        }
        field(101; "Show Request Page"; Boolean)
        {
            Caption = 'Show Report Request Page';
            Description = '';
        }
        field(120; "Use Distribution Selection"; Boolean)
        {
            Caption = 'Use Distribution Selection';
            Description = '';
        }
        field(200; "Subject Text"; Text[250])
        {
            Caption = 'Subject Text';
        }
        field(500; "SMTP Server"; Text[250])
        {
            Caption = 'SMTP Server';
        }
        field(510; Authentication; Option)
        {
            Caption = 'Authentication';
            OptionCaption = 'Anonymous,NTLM,Basic';
            OptionMembers = Anonymous,NTLM,Basic;
        }
        field(520; "User ID"; Text[250])
        {
            Caption = 'User ID';
        }
        field(540; "SMTP Server Port"; Integer)
        {
            Caption = 'SMTP Server Port';
            InitValue = 25;
        }
        field(550; "Secure Connection"; Boolean)
        {
            Caption = 'Secure Connection';
            InitValue = false;
        }
        field(560; "Password Key"; Guid)
        {
            Caption = 'Password Key';
        }
    }

    keys
    {
        key(Key1; "Email Distribution Code", "Language Code", "Use for Type", "Use for Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Email Distribution Code", Description)
        {
        }
    }

    procedure ShowAttachments()
    var
        EmailAttachmentSetup: Record "Email Distribution Attachment";
    begin
        EmailAttachmentSetup.FilterGroup(2);
        EmailAttachmentSetup.SetRange("Email Distribution Code", "Email Distribution Code");
        EmailAttachmentSetup.SetRange("Language Code", "Language Code");
        EmailAttachmentSetup.SetRange("Use for Type", "Use for Type");
        EmailAttachmentSetup.SetRange("Use for Code", "Use for Code");
        EmailAttachmentSetup.FilterGroup(0);
    end;


    procedure SetPassword(NewPassword: Text[250])
    begin
    end;


    procedure GetPassword(): Text[250]
    begin
    end;


    procedure HasPassword(): Boolean
    begin
        exit(GetPassword() <> '');
    end;
}