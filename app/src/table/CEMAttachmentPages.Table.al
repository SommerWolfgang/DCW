table 6086401 "CEM Attachment Pages"
{
    Caption = 'Attachment Pages';
    Permissions = TableData "CEM Expense" = rimd,
                  TableData "CEM Expense Inbox" = rimd;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Budget,Settlement';
            OptionMembers = Budget,Settlement;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Doc. Ref. No."; Integer)
        {
            Caption = 'Doc. Ref. No.';
        }
        field(6; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(11; "Attachment GUID"; Guid)
        {
            Caption = 'Attachment GUID';
        }
        field(12; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(13; Attachment; BLOB)
        {
            Caption = 'Attachment';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Entry No.", "Page No.")
        {
            Clustered = true;
        }
    }
    procedure SetPage(var TempFile: Record "CDC Temp File" temporary; ShowError: Boolean): Boolean
    begin
    end;

    procedure GetAzureBlobFilename() "1024": Text
    begin
    end;

    procedure GetFileExtension(): Text[3]
    begin
        exit('png'); // Pages are always PNG.
    end;


    procedure GetPageFileName(): Text[200]
    begin
        exit(Format("Page No.") + '.' + GetFileExtension());
    end;


    procedure GetCreatedDate(): Date
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense":
                if Expense.Get("Doc. Ref. No.") then
                    exit(Expense."Date Created");
            DATABASE::"CEM Mileage":
                if Mileage.Get("Doc. Ref. No.") then
                    exit(Mileage."Date Created");
        end;

        exit(Today);
    end;
}

