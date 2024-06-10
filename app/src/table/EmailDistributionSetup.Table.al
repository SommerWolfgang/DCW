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
            TableRelation = Language;

            trigger OnValidate()
            begin
                case "Use for Type" of
                    "Use for Type"::Customer:
                        begin
                            "Language Code" := '';
                        end;

                    "Use for Type"::Vendor:
                        begin
                            "Language Code" := '';
                        end;

                    "Use for Type"::Contact:
                        begin
                            "Language Code" := '';
                        end;
                end;
            end;
        }
        field(6; "Use for Type"; Option)
        {
            Caption = 'Use for Type';
            Description = '';
            OptionCaption = ' ,Customer,Vendor,Contact,Responsibility Center';
            OptionMembers = " ",Customer,Vendor,Contact,"Responsibility Center";

            trigger OnValidate()
            begin
                case "Use for Type" of
                    "Use for Type"::" ":
                        begin
                            "Language Code" := '';
                        end;

                    "Use for Type"::Customer:
                        begin
                            "Language Code" := '';
                        end;

                    "Use for Type"::Vendor:
                        begin
                            "Language Code" := '';
                        end;

                    "Use for Type"::Contact:
                        begin
                            "Language Code" := '';
                        end;
                end;
            end;
        }
        field(7; "Use for Code"; Code[20])
        {
            Caption = 'Use for Code';
            Description = '';
            TableRelation = IF ("Use for Type" = CONST(Customer)) Customer
            ELSE
            IF ("Use for Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Use for Type" = CONST(Contact)) Contact
            ELSE
            IF ("Use for Type" = CONST("Responsibility Center")) "Responsibility Center";

            trigger OnValidate()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
                case "Use for Type" of
                    "Use for Type"::" ":
                        begin
                            FieldError("Use for Type");
                        end;

                    "Use for Type"::Customer:
                        begin
                            if Customer.Get("Use for Code") and (Customer."Language Code" <> '') then begin
                                "Language Code" := Customer."Language Code";
                            end;
                        end;

                    "Use for Type"::Vendor:
                        begin
                            if Vendor.Get("Use for Code") and (Vendor."Language Code" <> '') then begin
                                "Language Code" := Vendor."Language Code";
                            end;
                        end;
                end;
            end;
        }
        field(10; Description; Text[30])
        {
            CalcFormula = Lookup("Email Distribution Code".Description WHERE(Code = FIELD("Email Distribution Code")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Mail Type"; Option)
        {
            Caption = 'Mail Type';
            OptionCaption = 'Outlook,SMTP';
            OptionMembers = Outlook,SMTP;

            trigger OnValidate()
            begin
                if "Mail Type" = "Mail Type"::Outlook then begin
                    Validate(Sender, Sender::"Current User");
                end else begin
                    "Hide Mail Dialog" := false;
                end;
            end;
        }
        field(30; Sender; Option)
        {
            Caption = 'Sender';
            OptionCaption = 'Current User,Fixed';
            OptionMembers = "Current User","Fixed";

            trigger OnValidate()
            begin
                if Sender = Sender::Fixed then begin
                    TestField("Mail Type", "Mail Type"::SMTP);
                    "Sender Address" := '';
                    "Sender Name" := '';
                end else begin
                    ClearSMTPSetup;
                    if "Mail Type" = "Mail Type"::SMTP then begin
                        InitSMTP;
                    end;
                end;
            end;
        }
        field(40; "Sender Address"; Text[80])
        {
            Caption = 'Sender Address';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                if "Sender Address" <> '' then begin
                    TestField(Sender, Sender::Fixed);
                    CheckValidEmailAddress("Sender Address");
                end;
            end;
        }
        field(50; "Sender Name"; Text[80])
        {
            Caption = 'Sender Name';

            trigger OnValidate()
            begin
                if "Sender Name" <> '' then begin
                    TestField(Sender, Sender::Fixed);
                end;
            end;
        }
        field(60; "Recipient Type"; Option)
        {
            Caption = 'Recipient Type';
            OptionCaption = 'Automatic,Fixed';
            OptionMembers = Automatic,"Fixed";

            trigger OnValidate()
            begin
                if "Recipient Type" = "Recipient Type"::Fixed then begin
                    "Recipient Address" := '';
                end else begin
                    if "Mail Type" = "Mail Type"::SMTP then begin
                        ClearSMTPSetup;
                        InitSMTP;
                    end;
                end;
            end;
        }
        field(70; "Recipient Address"; Text[80])
        {
            Caption = 'Recipient Address';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                if "Recipient Address" <> '' then begin
                    TestField("Recipient Type", "Recipient Type"::Fixed);
                    CheckValidEmailAddress("Recipient Address");
                end;
            end;
        }
        field(80; "Cc Recipients"; Text[250])
        {
            Caption = 'Cc Recipients';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                if "Cc Recipients" <> '' then begin
                    CheckValidEmailAddresses("Cc Recipients");
                end;
            end;
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

            trigger OnValidate()
            begin
                if "Hide Mail Dialog" then begin

                end;
            end;
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

            trigger OnValidate()
            begin
                if "Subject Text" <> '' then begin
                    TestField("Subject Line Format", "Subject Line Format"::"Subject Text");
                end;
            end;
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

            trigger OnValidate()
            begin
                if Authentication <> Authentication::Basic then begin
                    "User ID" := '';
                    SetPassword('');
                end;
            end;
        }
        field(520; "User ID"; Text[250])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                TestField(Authentication, Authentication::Basic);
            end;
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

            trigger OnValidate()
            begin
                if "Secure Connection" <> xRec."Secure Connection" then begin
                    if "Secure Connection" then begin
                        "SMTP Server Port" := 587;
                    end else begin
                        "SMTP Server Port" := 25;
                    end;
                end;
            end;
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

    trigger OnDelete()
    var
        EmailAttachmentSetup: Record "Email Distribution Attachment";
        TMDelete: Codeunit "Text Module Delete";
    begin
        EmailAttachmentSetup.SetRange("Email Distribution Code", "Email Distribution Code");
        if not EmailAttachmentSetup.IsEmpty then begin
            EmailAttachmentSetup.DeleteAll;
        end;
    end;

    trigger OnRename()
    var
        TMFunctions: Codeunit "Text Module Functions";
    begin
    end;

    var
        ChangeLogMgt: Codeunit "Change Log Management";
        Text001: Label 'The email address "%1" is invalid.';

    local procedure CheckValidEmailAddresses(Recipients: Text)
    var
        TmpRecipients: Text;
    begin
        if Recipients = '' then begin
            Error(Text001, Recipients);
        end;

        TmpRecipients := Recipients;
        while StrPos(TmpRecipients, ';') > 1 do begin
            CheckValidEmailAddress(CopyStr(TmpRecipients, 1, StrPos(TmpRecipients, ';') - 1));
            TmpRecipients := CopyStr(TmpRecipients, StrPos(TmpRecipients, ';') + 1);
        end;
        CheckValidEmailAddress(TmpRecipients);
    end;

    local procedure CheckValidEmailAddress(EmailAddress: Text)
    var
        i: Integer;
        NoOfAtSigns: Integer;
    begin
        if EmailAddress = '' then begin
            Error(Text001, EmailAddress);
        end;

        if (EmailAddress[1] = '@') or (EmailAddress[StrLen(EmailAddress)] = '@') then begin
            Error(Text001, EmailAddress);
        end;

        for i := 1 to StrLen(EmailAddress) do begin
            if EmailAddress[i] = '@' then begin
                NoOfAtSigns := NoOfAtSigns + 1
            end else begin
                if EmailAddress[i] = ' ' then begin
                    Error(Text001, EmailAddress);
                end;
            end;
        end;

        if NoOfAtSigns <> 1 then begin
            Error(Text001, EmailAddress);
        end;
    end;

    local procedure ClearSMTPSetup()
    begin
        "SMTP Server" := '';
        Authentication := Authentication::Anonymous;
        "User ID" := '';
        SetPassword('');
        "SMTP Server Port" := 0;
        "Secure Connection" := false;
    end;

    local procedure InitSMTP()
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
    begin
        if SMTPMailSetup.Get then begin
            "Sender Address" := SMTPMailSetup."User ID";
            "Sender Name" := "Sender Address";
        end;
    end;


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
        PAGE.Run(PAGE::"Email Attachment Setup", EmailAttachmentSetup);
    end;


    procedure SetPassword(NewPassword: Text[250])
    var
        ServicePassword: Record "Service Password";
    begin
        if IsNullGuid("Password Key") or not ServicePassword.Get("Password Key") then begin
            ServicePassword.SavePassword(NewPassword);
            ServicePassword.Insert(true);
            "Password Key" := ServicePassword.Key;
        end else begin
            ServicePassword.SavePassword(NewPassword);
            ServicePassword.Modify;
        end;
    end;


    procedure GetPassword(): Text[250]
    var
        ServicePassword: Record "Service Password";
    begin
        if not IsNullGuid("Password Key") then
            if ServicePassword.Get("Password Key") then
                exit(ServicePassword.GetPassword);
        exit('');
    end;


    procedure HasPassword(): Boolean
    begin
        exit(GetPassword <> '');
    end;
}

