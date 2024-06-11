table 6086363 "CEM Attachment Inbox"
{
    Caption = 'EM Attachment Inbox';
    DataCaptionFields = "Entry No.", "File Name";
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
            TableRelation = if ("Table ID" = const(6086323)) "CEM Expense Inbox"
            else
            if ("Table ID" = const(6086353)) "CEM Mileage Inbox";
        }
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
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
        field(15; "Attachment Signed"; BLOB)
        {
            Caption = 'Attachment Signed';
        }
        field(16; "Attachment Signed Hash Value"; Text[50])
        {
            Caption = 'Attachment Signed Hash Value';
            Editable = false;
        }
        field(20; Changeable; Boolean)
        {
            Caption = 'Changeable';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Doc. Ref. No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        TempFile: Record "CDC Temp File" temporary;
    begin
        if "Table ID" = DATABASE::"CEM Expense" then begin
            GetAttachmentServerFile(TempFile);
            TempFile.DeleteFile();
        end;
    end;

    trigger OnInsert()
    var
        EMAttachmentInbox: Record "CEM Attachment Inbox";
    begin
        EMAttachmentInbox.SetRange("Table ID", "Table ID");
        EMAttachmentInbox.SetRange("Document Type", "Document Type");
        EMAttachmentInbox.SetRange("Document No.", "Document No.");
        EMAttachmentInbox.SetRange("Doc. Ref. No.", "Doc. Ref. No.");
        if EMAttachmentInbox.FindLast() then
            "Entry No." := EMAttachmentInbox."Entry No." + 1
        else
            "Entry No." := 1;

        "Attachment GUID" := CreateGuid();
    end;

    var
        ContCompSetup: Record "CDC Continia Company Setup";
        EMSetup: Record "CEM Expense Management Setup";
        GotCompSetup: Boolean;
        GotEMSetup: Boolean;
        FileMove: Label 'The file was moved and it cannot be visualized anymore.';
        _CompName: Text[30];


    procedure GetCreatedDate(): Date
    var
        ExpenseInbox: Record "CEM Expense Inbox";
        MileageInbox: Record "CEM Mileage Inbox";
    begin
        case "Table ID" of
            DATABASE::"CEM Expense Inbox":
                begin
                    if _CompName <> '' then
                        ExpenseInbox.ChangeCompany(_CompName);

                    if ExpenseInbox.Get("Doc. Ref. No.") then
                        exit(DT2Date(ExpenseInbox."Imported Date/Time"));
                end;

            DATABASE::"CEM Mileage Inbox":
                begin
                    if _CompName <> '' then
                        MileageInbox.ChangeCompany(_CompName);

                    if MileageInbox.Get("Doc. Ref. No.") then
                        exit(MileageInbox."Date Created");
                end;
        end;

        exit(Today);
    end;


    procedure OpenFile()
    var
        TempFile: Record "CDC Temp File" temporary;
    begin
        if InboxAccepted() then
            Error(FileMove);

        if GetAttachmentServerFile(TempFile) then
            TempFile.Open();
    end;


    procedure SetSetup(var NewEMSetup: Record "CEM Expense Management Setup"; var NewContCompSetup: Record "CDC Continia Company Setup")
    begin
    end;


    procedure HasAttachment(): Boolean
    begin
    end;


    procedure HasPDF(): Boolean
    begin
    end;


    procedure SetAttachment(var TempFile: Record "CDC Temp File" temporary): Boolean
    begin
    end;


    procedure SetPDF(var TempFile: Record "CDC Temp File" temporary): Boolean
    begin
    end;


    procedure SetHashValue()
    begin
    end;

    procedure GetAttachmentServerFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    begin
    end;

    procedure GetPDFServerFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    begin
    end;

    procedure ClearAttachment(): Boolean
    begin
    end;

    procedure ClearPDF(): Boolean
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


    procedure ClearPages(): Boolean
    begin
    end;

    procedure GetAzureBlobFilename(): Text[1024]
    begin
    end;

    procedure GetAzureBlobFilenameForPDF(): Text[1024]
    begin
    end;

    procedure GetFileExtension(): Text[20]
    begin
    end;

    procedure SetCurrCompany(CompName: Text[30])
    begin
    end;
}