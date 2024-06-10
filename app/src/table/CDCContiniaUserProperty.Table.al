table 6085780 "CDC Continia User Property"
{
    Caption = 'Continia User Property';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(2; "Image Zoom"; Integer)
        {
            Caption = 'Image Zoom';
        }
        field(3; "Add-In Min Width"; Integer)
        {
            Caption = 'Add-In Min Width';
        }
        field(5; "Selected Scanner"; Code[50])
        {
            Caption = 'Selected Scanner';
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetSelectedScanner(): Code[50]
    begin
        if not Get(UserId) then
            exit;

        exit("Selected Scanner");
    end;


    procedure SetSelectedScanner(ScannerCode: Code[50])
    begin
        if not Get(UserId) then begin
            "User ID" := UserId;
            Insert;
        end;

        "Selected Scanner" := ScannerCode;
        Modify;
    end;
}

