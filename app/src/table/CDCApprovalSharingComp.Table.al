table 6085764 "CDC Approval Sharing (Comp.)"
{
    Caption = 'Approval Sharing';
    Permissions = TableData "CDC Approval Sharing (Comp.)" = rimd;

    fields
    {
        field(1; "Owner User ID"; Code[50])
        {
            Caption = 'Owner User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
        }
        field(2; "Shared to User ID"; Code[50])
        {
            Caption = 'Shared to User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
        }
        field(3; "Sharing Type"; Option)
        {
            Caption = 'Sharing Type';
            OptionCaption = 'Normal,Out of Office';
            OptionMembers = Normal,"Out of Office";
        }
        field(4; "Valid From"; Date)
        {
            Caption = 'Valid From';
        }
        field(5; "Valid To"; Date)
        {
            Caption = 'Valid To';
        }
        field(6; "Use Owners Limts & Permissions"; Boolean)
        {
            Caption = 'Use Owners Limts && Permissions';
        }
        field(7; "Display Order"; Integer)
        {
            Caption = 'Display Order';
        }
        field(8; "Forward E-mails"; Boolean)
        {
            Caption = 'Forward Emails';
        }
        field(9; "Copy to All Companies"; Boolean)
        {
            Caption = 'Copy to All Companies';
        }
        field(100; "Company Name"; Text[250])
        {
            Caption = 'Company Name';
        }
    }

    keys
    {
        key(Key1; "Owner User ID", "Shared to User ID", "Sharing Type", "Valid From", "Valid To")
        {
            Clustered = true;
        }
        key(Key2; "Shared to User ID", "Sharing Type", "Valid From", "Valid To")
        {
        }
        key(Key3; "Display Order")
        {
        }
    }
    procedure LookupUserID(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;

    procedure ValidateUserID(_UserId: Code[50])
    begin
    end;
}