table 12032507 "Email Distribution Attachment"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland


    fields
    {
        field(1; "Email Distribution Code"; Code[10])
        {
            Caption = 'Email Distribution Code';
            NotBlank = true;
            TableRelation = "Email Distribution Setup"."Email Distribution Code";
        }
        field(5; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
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
            TableRelation = if ("Use for Type" = const(Customer)) Customer
            else
            if ("Use for Type" = const(Vendor)) Vendor
            else
            if ("Use for Type" = const(Contact)) Contact
            else
            if ("Use for Type" = const("Responsibility Center")) "Responsibility Center";

            trigger OnValidate()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
                if "Use for Code" <> '' then
                    case "Use for Type" of

                        "Use for Type"::" ":
                            begin
                                FieldError("Use for Type");
                            end;

                        "Use for Type"::Customer:
                            begin
                                if Customer.Get("Use for Code") and (Customer."Language Code" <> '') then
                                    "Language Code" := Customer."Language Code";
                            end;

                        "Use for Type"::Vendor:
                            begin
                                if Vendor.Get("Use for Code") and (Vendor."Language Code" <> '') then
                                    "Language Code" := Vendor."Language Code";
                            end;

                    end;
            end;
        }
        field(9; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(15; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(16; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(50; "File BLOB"; BLOB)
        {
            Caption = 'File Uploaded';
        }
        field(51; "Display File Name"; Text[80])
        {
            Caption = 'File Name';
            NotBlank = true;

            trigger OnValidate()
            begin
                if Description = '' then begin
                    Description := CopyStr("Display File Name", 1, 30);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Email Distribution Code", "Language Code", "Use for Type", "Use for Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        EmailAttachmentSetup: Record "Email Distribution Attachment";
    begin
        EmailAttachmentSetup := Rec;
        EmailAttachmentSetup.SetRecFilter();
        EmailAttachmentSetup.SetRange("Line No.");
        if EmailAttachmentSetup.FindLast() then begin
            "Line No." := EmailAttachmentSetup."Line No." + 1;
        end else begin
            "Line No." := 1;
        end;
    end;

    var
        TextDownloadFileDialog: Label 'Download File';
        TextFilterAllFiles: Label 'All Files|*.*';
        TextUploadFileDialog: Label 'Upload File';


    procedure UploadFile(ClientFileName: Text)
    begin
    end;

    procedure DownloadFile(ClientFileName: Text)
    begin
    end;
}