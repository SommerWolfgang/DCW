table 6086402 "CEM Attachment Pages Inbox"
{
    Caption = 'Attachment Pages Inbox';
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
        field(12; "Attachment GUID"; Guid)
        {
            Caption = 'Attachment GUID';
        }
        field(13; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(14; Attachment; BLOB)
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
    procedure GetCreatedDate(): Date
    var
        ExpenseInbox: Record "CEM Expense Inbox";
        MileageInbox: Record "CEM Mileage Inbox";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense Inbox":
                if ExpenseInbox.Get("Doc. Ref. No.") then
                    exit(DT2Date(ExpenseInbox."Imported Date/Time"));
            DATABASE::"CEM Mileage Inbox":
                if MileageInbox.Get("Doc. Ref. No.") then
                    exit(MileageInbox."Date Created");
        end;

        exit(Today);
    end;


    procedure SetPage(var TempFile: Record "CDC Temp File" temporary): Boolean
    begin
    end;


    procedure GetPageServerFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    begin
    end;


    procedure GetAzureBlobFilename() "1024": Text
    begin
    end;

    procedure InboxAccepted(): Boolean
    var
        ExpenseInbox: Record "CEM Expense Inbox";
        MileageInbox: Record "CEM Mileage Inbox";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense Inbox":
                begin
                    ExpenseInbox.Get("Doc. Ref. No.");
                    exit(ExpenseInbox.Status = ExpenseInbox.Status::Accepted);
                end;

            DATABASE::"CEM Mileage Inbox":
                begin
                    MileageInbox.Get("Doc. Ref. No.");
                    exit(MileageInbox.Status = MileageInbox.Status::Accepted);
                end;
        end;
    end;
}