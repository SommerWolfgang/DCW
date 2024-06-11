table 6085601 "CDC Document (UIC)"
{
    Caption = 'Document (Unidentified Company)';
    DataPerCompany = false;

    fields
    {
        field(2; "Document Category Code"; Code[10])
        {
            Caption = 'Document Category Code';
            NotBlank = true;
        }
        field(3; "TIFF Image File"; BLOB)
        {
            Caption = 'TIFF Image File';
        }
        field(10; Filename; Code[100])
        {
            Caption = 'Filename';
        }
        field(20; "PDF File"; BLOB)
        {
            Caption = 'PDF File';
        }
        field(22; "XML File"; BLOB)
        {
            Caption = 'XML File';
        }
        field(23; "HTML File"; BLOB)
        {
            Caption = 'HTML File';
        }
        field(25; "Imported by"; Code[50])
        {
            Caption = 'Imported by';
        }
        field(26; "Imported Date-Time"; DateTime)
        {
            Caption = 'Imported Date-Time';
        }
        field(28; "File Type"; Option)
        {
            Caption = 'File Type';
            Editable = false;
            OptionCaption = 'OCR,,,,Miscellaneous,XML';
            OptionMembers = OCR,,,,Miscellaneous,XML;
        }
        field(29; "File Extension"; Text[30])
        {
            Caption = 'File Extension';
            Editable = false;
        }
        field(31; "From E-Mail Address"; Text[200])
        {
            Caption = 'From Email Address';
        }
        field(32; "From E-Mail Name"; Text[200])
        {
            Caption = 'From Email Name';
        }
        field(33; "To E-Mail Address"; Text[200])
        {
            Caption = 'To Email Address';
        }
        field(34; "To E-Mail Name"; Text[200])
        {
            Caption = 'To Email Name';
        }
        field(35; "E-Mail Date"; DateTime)
        {
            Caption = 'Email Date';
        }
        field(36; "E-Mail Inbox Subfolder"; Text[200])
        {
            Caption = 'Inbox Subfolder';
        }
        field(37; "E-Mail Subject"; Text[200])
        {
            Caption = 'Email Subject';
        }
        field(38; "E-Mail GUID"; Guid)
        {
            Caption = 'Email GUID';
        }
        field(40; "PDF File Hash"; Text[50])
        {
            Caption = 'PDF File Hash';
        }
        field(41; "Status Code"; Code[10])
        {
            Caption = 'Status Code';
            TableRelation = "CDC Document Status Code";
        }
        field(42; "OCR Process Completed"; DateTime)
        {
            Caption = 'OCR Process Completed';
        }
        field(53; "Import Day"; Integer)
        {
            Caption = 'Import Day';
        }
        field(54; "Import Month"; Integer)
        {
            Caption = 'Import Month';
        }
        field(55; "Import Year"; Integer)
        {
            Caption = 'Import Year';
        }
        field(80; "Storage Migration Pending"; Boolean)
        {
            Caption = 'Storage Migration Pending';
        }
        field(100; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(101; "Move To Company"; Text[30])
        {
            Caption = 'Move to Company';
        }
        field(102; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Rejected';
            OptionMembers = Open,Rejected;
        }
        field(107; "Filename 2"; Code[99])
        {
            Caption = 'Filename 2';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Document Category Code")
        {
            Clustered = true;
        }
        key(Key3; "E-Mail GUID")
        {
        }
        key(Key4; "Document Category Code", Status)
        {
        }
        key(Key5; "Storage Migration Pending")
        {
        }
    }
    procedure OpenTiffImageFile()
    begin
    end;

    procedure OpenPdfFile()
    begin
    end;

    procedure OpenEMailFile()
    begin
    end;

    procedure OpenXmlFile()
    begin
    end;

    procedure GetTiffFileName() FullFileName: Text[1024]
    begin
    end;

    procedure GetPdfFileName(): Text[1024]
    begin
    end;

    procedure GetEMailFileName(): Text[1024]
    begin
    end;

    procedure HasTiffFile(): Boolean
    begin
    end;

    procedure HasPdfFile(): Boolean
    begin
    end;

    procedure HasEmailFile(): Boolean
    begin
    end;

    procedure HasXmlFile(): Boolean
    begin
    end;

    procedure HasHtmlFile(): Boolean
    begin
    end;

    procedure ClearTiffFile(): Boolean
    begin
    end;

    procedure ClearPdfFile(): Boolean
    begin
    end;

    procedure ClearEmailFile(): Boolean
    begin
    end;

    procedure ClearXmlFile(): Boolean
    begin
    end;

    // procedure GetTiffFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetPdfFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetEmailFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    //    procedure GetXmlFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    //     begin
    //    end;

    //     procedure GetPngFile(var TempFile: Record "CDC Temp File" temporary; PageNo: Integer): Boolean
    //     begin
    //     end;

    //     procedure SetTiffFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    //     begin
    //     end;

    //     procedure SetPdfFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    //     begin
    //     end;

    // procedure SetEmailFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure SetXmlFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    procedure GetEmailGUIDAsText(): Text[50]
    begin
    end;

    procedure Reject()
    begin
    end;

    procedure Reopen()
    begin
    end;

    procedure CreateDirectory(FullFilename: Text[1024])
    begin
    end;

    procedure SetDCSetup(NewDCSetup: Record "CDC Document Capture Setup")
    begin
    end;

    // procedure BuildXmlBuffer(var XMLBuffer: Record "CDC XML Buffer" temporary): Boolean
    // begin
    // end;

    procedure OpenXmlViewer()
    begin
    end;

    procedure TransferFieldsToDoc(var Document: Record "CDC Document"; CompanyName: Text[50])
    begin
    end;

    procedure TransferFieldsFromDoc(var Document: Record "CDC Document")
    begin
    end;

    procedure HasVisualFile(): Boolean
    begin
    end;

    // procedure GetVisualFile(var TempFile: Record "CDC Temp File"): Boolean
    // begin
    // end;

    // procedure GetHtmlFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    procedure SetCurrentCompany(NewCompanyName: Text[30])
    begin
    end;
}