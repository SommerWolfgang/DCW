table 6086018 "CDC Delegation Sharing"
{
    Caption = 'Delegation Sharing';
    DataCaptionFields = "Owner User ID", "Shared to User ID";
    Permissions = TableData "CDC Approval Sharing" = rimd;

    fields
    {
        field(1; "Owner User ID"; Code[50])
        {
            Caption = 'Owner User ID';
            NotBlank = true;
        }
        field(2; "Shared to User ID"; Code[50])
        {
            Caption = 'Shared to User ID';
            NotBlank = true;
        }
        field(4; "Valid From"; Date)
        {
            Caption = 'Valid From';
        }
        field(5; "Valid To"; Date)
        {
            Caption = 'Valid To';
        }
        field(7; "Display Order"; Integer)
        {
            Caption = 'Display Order';
        }
        field(9; "Copy to All Companies"; Boolean)
        {
            Caption = 'Copy to All Companies';
        }
    }

    keys
    {
        key(Key1; "Owner User ID", "Shared to User ID", "Valid From", "Valid To")
        {
            Clustered = true;
        }
        key(Key2; "Shared to User ID", "Valid From", "Valid To")
        {
        }
        key(Key3; "Display Order")
        {
        }
    }
    procedure InsertInAllCompanies()
    begin
    end;

    procedure ModifyInAllCompanies()
    begin
    end;

    procedure DeleteFromAllCompanies()
    begin
    end;

    procedure RenameInAllCompanies()
    begin
    end;

    procedure DeleteAllOutOfOffice(DelegatedToUserId: Code[50]; DeleteInAllOtherCompanies: Boolean; ExcludeOption: Option "None",xRec,Rec)
    begin
    end;
}