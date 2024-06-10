table 6086359 "CEM Attachment"
{
    Caption = 'Attachment';
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
            TableRelation = IF ("Table ID" = CONST(6086320)) "CEM Expense"
            ELSE
            IF ("Table ID" = CONST(6086338)) "CEM Mileage";
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

    procedure OpenFile(Type: Option Original,Signed)
    begin
    end;

    procedure GetCreatedDate(): Date
    begin
    end;

    procedure SetHideUI()
    begin
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

    procedure SetAttachment(var TempFile: Record "CDC Temp File" temporary; ShowError: Boolean): Boolean
    begin
    end;

    procedure SetPDF(var TempFile: Record "CDC Temp File" temporary; ShowError: Boolean): Boolean
    begin
    end;

    procedure GetAttachmentClientFilename(): Text[1024]
    begin
    end;

    procedure GetAttachment(var TempFile: Record "CDC Temp File" temporary): Boolean
    begin
    end;

    procedure GetPDF(var TempFile: Record "CDC Temp File" temporary): Boolean
    begin
    end;

    procedure ClearAttachment(): Boolean
    begin
    end;

    procedure ClearPDF(): Boolean
    begin
    end;

    procedure CheckFileNameLen(FileName: Text[200])
    begin
    end;

    procedure ConvertToPdfAndSign()
    begin
    end;

    procedure SetHashValue()
    begin
    end;

    procedure ConvertToPagesAndStore()
    begin
    end;

    procedure GetFileExtension(): Text[20]
    begin
    end;

    procedure IsPdfFormat(): Boolean
    begin
    end;

    procedure ClearPages()
    begin
    end;

    procedure HasPages(): Boolean
    begin
    end;

    procedure GetPageByNo(var TempFile: Record "CDC Temp File" temporary; PageNo: Integer): Boolean
    begin
    end;

    procedure GetNoOfPages(): Integer
    begin
    end;

    procedure LoadPages(var PageList: Record "CDC Temp File" temporary; NoOfPages: Integer)
    begin
    end;

    procedure GetAzureBlobFilename(): Text[1024]
    begin
    end;

    procedure GetAzureBlobFilenameSignedPDF(): Text[1024]
    begin
    end;
}