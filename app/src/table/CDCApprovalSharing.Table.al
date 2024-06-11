table 6085749 "CDC Approval Sharing"
{
    Caption = 'Approval Sharing';
    DataCaptionFields = "Owner User ID", "Shared to User ID";
    Permissions = TableData "CDC Approval Sharing" = rimd;

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
            Caption = 'Use Owners Limits && Permissions';
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
    procedure ModifyInAllCompanies()
    begin
    end;

    procedure DeleteFromAllCompanies()
    begin
    end;

    procedure RenameInAllCompanies()
    begin
    end;

    procedure DeleteAllOutOfOffice(ApproverId: Code[50]; DeleteInAllOtherCompanies: Boolean; ExcludeOption: Option "None",xRec,Rec)
    begin
    end;
}