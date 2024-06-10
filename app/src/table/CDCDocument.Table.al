table 6085590 "CDC Document"
{
    Caption = 'Document';
    DataCaptionFields = "No.";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "Document Category Code"; Code[10])
        {
            Caption = 'Document Category Code';
            NotBlank = true;
        }
        field(3; "TIFF Image File"; BLOB)
        {
            Caption = 'TIFF Image File';
        }
        field(6; "Template No."; Code[20])
        {
            Caption = 'Template No.';
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Registered,Rejected';
            OptionMembers = Open,Registered,Rejected;

            trigger OnValidate()
            begin
                if Status = Status::Open then begin
                    "Amount Excl. VAT" := 0;
                    "Amount Incl. VAT" := 0;
                    "Created Doc. Table No." := 0;
                    "Created Doc. Subtype" := 0;
                    "Created Doc. No." := '';
                    "Created Doc. Ref. No." := 0;
                    Description := '';
                    exit;
                end;

                "Date-Time for Register/Reject" := CurrentDateTime;

                LogDocumentUsageIfValid;
            end;
        }
        field(8; "No. of Pages"; Integer)
        {
            CalcFormula = Count("CDC Document Page" WHERE("Document No." = FIELD("No.")));
            Caption = 'No. of Pages';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; OK; Boolean)
        {
            Caption = 'OK';
            Editable = false;
        }
        field(10; Filename; Code[100])
        {
            Caption = 'Filename';
            Editable = false;
        }
        field(11; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(13; "Created Doc. Table No."; Integer)
        {
            Caption = 'Created Doc. Table No.';
            Editable = false;
        }
        field(14; "Created Doc. Subtype"; Integer)
        {
            Caption = 'Created Doc. Subtype';
            Editable = false;
        }
        field(15; "Created Doc. No."; Code[20])
        {
            Caption = 'Created Doc. No.';
            Editable = false;
        }
        field(16; "Created Doc. Ref. No."; Integer)
        {
            Caption = 'Created Doc. Ref. No.';
            Editable = false;
        }
        field(17; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(18; "Match Status"; Option)
        {
            Caption = 'Match Status';
            Editable = false;
            OptionCaption = 'Unmatched,Automatically Matched,Manually Matched';
            OptionMembers = Unmatched,"Automatically Matched","Manually Matched";
        }
        field(19; "Show after Register"; Boolean)
        {
            Caption = 'Show After Register';
            Editable = false;
        }
        field(20; "PDF File"; BLOB)
        {
            Caption = 'PDF File';
        }
        field(21; "Misc. File"; BLOB)
        {
            Caption = 'Misc. File';
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
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(26; "Imported Date-Time"; DateTime)
        {
            Caption = 'Imported Date-Time';
            Editable = false;
        }
        field(27; "Date-Time for Register/Reject"; DateTime)
        {
            Caption = 'Date-Time for Register/Reject';
            Editable = false;
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
        field(30; "Allow Delete"; Boolean)
        {
            Caption = 'Allow Delete';
            Editable = false;
        }
        field(31; "From E-Mail Address"; Text[200])
        {
            Caption = 'From Email Address';
            Editable = false;
        }
        field(32; "From E-Mail Name"; Text[200])
        {
            Caption = 'From Email Name';
            Editable = false;
        }
        field(33; "To E-Mail Address"; Text[200])
        {
            Caption = 'To Email Address';
            Editable = false;
        }
        field(34; "To E-Mail Name"; Text[200])
        {
            Caption = 'To Email Name';
            Editable = false;
        }
        field(35; "E-Mail Date"; DateTime)
        {
            Caption = 'Email Date';
            Editable = false;
        }
        field(36; "E-Mail Inbox Subfolder"; Text[200])
        {
            Caption = 'Inbox Subfolder';
            Editable = false;
        }
        field(37; "E-Mail Subject"; Text[200])
        {
            Caption = 'Email Subject';
            Editable = false;
        }
        field(38; "E-Mail GUID"; Guid)
        {
            Caption = 'Email GUID';
            Editable = false;
        }
        field(39; "Batch Register"; Boolean)
        {
            Caption = 'Batch Register';
            Editable = false;
        }
        field(40; "PDF File Hash"; Text[50])
        {
            Caption = 'PDF File Hash';
            Editable = false;
        }
        field(41; "Status Code"; Code[10])
        {
            Caption = 'Status Code';
            TableRelation = "CDC Document Status Code";
        }
        field(42; "OCR Process Completed"; DateTime)
        {
            Caption = 'OCR Process Completed';
            Editable = false;
        }
        field(45; "Source Record Table ID"; Integer)
        {
            Caption = 'Source Record Table ID';
            NotBlank = false;
        }
        field(46; "Source Record No."; Code[50])
        {
            Caption = 'Source Record No.';
        }
        field(47; "Source Record Name"; Text[100])
        {
            Caption = 'Source Record Name';
            Editable = false;
        }
        field(48; Version; Integer)
        {
            Caption = 'Version';
            Editable = false;
        }
        field(50; "Amount Excl. VAT"; Decimal)
        {
            Caption = 'Amount Excl. VAT';
            Editable = false;
        }
        field(51; "Amount Incl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
            Editable = false;
        }
        field(53; "Import Day"; Integer)
        {
            Caption = 'Import Day';
            Editable = false;
        }
        field(54; "Import Month"; Integer)
        {
            Caption = 'Import Month';
            Editable = false;
        }
        field(55; "Import Year"; Integer)
        {
            Caption = 'Import Year';
        }
        field(60; "Identification Barcode"; Code[50])
        {
            Caption = 'Identification Barcode';
            Editable = false;
        }
        field(61; "Source Record ID Tree ID"; Integer)
        {
            Caption = 'Source Record ID Tree ID';
            Editable = false;
        }
        field(62; "Document Status Text"; Text[100])
        {
            Caption = 'Document Status Text';
            Editable = false;
        }
        field(65; "Force Register"; Boolean)
        {
            Caption = 'Force Register';
        }
        field(70; "Usage Entry No."; Integer)
        {
            Caption = 'Usage Entry No.';
            Editable = false;
        }
        field(75; "Identified by"; Text[250])
        {
            Caption = 'Identified by';
            Editable = false;
        }
        field(80; "Storage Migration Pending"; Boolean)
        {
            Caption = 'Storage Migration Pending';
        }
        field(100; "XML Master Template No."; Code[20])
        {
            Caption = 'XML Master Template No.';
        }
        field(101; "XML Identification Points"; Integer)
        {
            Caption = 'XML Identification Points';
        }
        field(102; "Temp Ident. Template No."; Code[20])
        {
            Caption = 'Temp Ident. Template No.';
        }
        field(103; "XML Document Type"; Option)
        {
            Caption = 'XML Document Type';
            OptionCaption = ' ,Invoice,Credit Memo';
            OptionMembers = " ",Invoice,CreditMemo;
        }
        field(104; "Temp Master Template No."; Code[20])
        {
            Caption = 'Temp Ident. Template No.';
        }
        field(105; "XML Ident. Template No."; Code[20])
        {
            Caption = 'Ident. Template No.';
        }
        field(106; "Clean XML File"; BLOB)
        {
            Caption = 'XML File without Namespaces';
        }
        field(107; "Filename 2"; Code[99])
        {
            Caption = 'Filename 2';
            Editable = false;
        }
        field(108; "Delegated To User ID"; Code[50])
        {
            Caption = 'Assigned to User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(109; "Temp Page No."; Integer)
        {
            Caption = 'Temp Page No.';
        }
        field(110; "Related Document No."; Code[20])
        {
            Caption = 'Related Document No.';
            TableRelation = "CDC Document";
        }
        field(200; "CDN GUID"; Guid)
        {
            Caption = 'CDN GUID';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Status)
        {
        }
        key(Key3; "Document Category Code", Status)
        {
        }
        key(Key4; "Template No.", Status)
        {
        }
        key(Key5; "Source Record ID Tree ID")
        {
        }
        key(Key6; Filename)
        {
        }
        key(Key7; "Created Doc. Table No.", "Created Doc. Subtype", "Created Doc. No.", "Created Doc. Ref. No.")
        {
        }
        key(Key8; "Document Category Code")
        {
        }
        key(Key9; "E-Mail GUID")
        {
        }
        key(Key10; "Source Record Table ID", "Source Record No.", "Document Category Code")
        {
        }
        key(Key11; "Storage Migration Pending")
        {
        }
        key(Key12; "Related Document No.")
        {
        }
    }
    procedure GetSourceNoCaption(): Text[50]
    begin
    end;

    procedure GetSourceNameCaption(): Text[50]
    begin
    end;

    procedure GetSourceName(): Text[1024]
    begin
    end;

    procedure GetDefaultTemplate(CreateNew: Boolean): Code[20]
    begin
    end;

    procedure DeleteComments("Area": Integer)
    var
        Comment: Record "CDC Document Comment";
    begin
        Comment.SetCurrentKey("Document No.");
        Comment.SetRange("Document No.", "No.");
        if Area = -2 then
            Comment.SetFilter(Area, '<>%1', Comment.Area::Import)
        else
            if Area >= 0 then
                Comment.SetRange(Area, Area);
        if not Comment.IsEmpty then
            Comment.DeleteAll;
    end;

    procedure HasWarningComments(): Boolean
    var
        Comment: Record "CDC Document Comment";
    begin
        Comment.SetCurrentKey("Document No.");
        Comment.SetRange("Document No.", "No.");
        Comment.SetRange("Comment Type", Comment."Comment Type"::Warning);
        exit(not Comment.IsEmpty);
    end;

    procedure HasDocumentLines(): Boolean
    var
        DocValue: Record "CDC Document Value";
    begin
        DocValue.SetRange("Document No.", "No.");
        DocValue.SetRange(Type, DocValue.Type::Line);
        DocValue.SetRange("Is Value", true);
        exit(not (DocValue.IsEmpty));
    end;

    procedure BuildTempLinesTable(var DocumentLine: Record "CDC Temp. Document Line")
    begin
    end;

    procedure BuildTempLinesTable2(var DocumentLine: Record "CDC Temp. Document Line"; CreateComments: Boolean)
    begin
    end;

    procedure GetValueAsText(FieldCode: Code[20]; LineNo: Integer): Text[250]
    begin
    end;

    procedure AfterCapture()
    begin
    end;

    procedure ValidateDocument()
    begin
    end;

    procedure Register()
    begin
    end;

    procedure RegisterYN()
    begin
    end;

    procedure RegisterHideErrors(): Boolean
    begin
    end;

    procedure Reject()
    begin
    end;

    procedure Reopen()
    begin
    end;

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

    procedure OpenHtmlFile()
    begin
    end;

    procedure OpenDocFile()
    begin
    end;

    procedure ShowRegisteredDoc()
    begin
    end;

    procedure TestStatus()
    begin
    end;

    procedure TestSourceNoAndTemplNo()
    begin
    end;

    procedure GetTiffFileName() FullFileName: Text[1024]
    begin
    end;

    procedure GetPdfFileName(): Text[1024]
    begin
    end;

    procedure GetMiscFileName(WriteProtected: Boolean): Text[1024]
    begin
    end;

    procedure GetEMailFileName(): Text[1024]
    begin
    end;

    procedure GetHtmlFileName(): Text[1024]
    begin
    end;

    procedure GetXmlFileName(): Text[1024]
    begin
    end;

    procedure GetDocFileDescription(): Text[1024]
    begin
    end;

    procedure HasTiffFile(): Boolean
    begin
    end;

    procedure HasPdfFile(): Boolean
    begin
    end;

    procedure HasMiscFile(): Boolean
    begin
    end;

    procedure HasEmailFile(): Boolean
    begin
    end;

    procedure HasXmlFile(): Boolean
    begin
    end;

    procedure HasCleanXmlFile(): Boolean
    begin
    end;

    procedure HasHtmlFile(): Boolean
    begin
    end;

    procedure HasPngFile(PageNo: Integer): Boolean
    begin
    end;

    procedure HasVisualFile(): Boolean
    begin
    end;

    procedure ClearTiffFile(): Boolean
    begin
    end;

    procedure ClearPdfFile(): Boolean
    begin
    end;

    procedure ClearMiscFile(): Boolean
    begin
    end;

    procedure ClearEmailFile(): Boolean
    begin
    end;

    procedure ClearXmlFile(): Boolean
    begin
    end;

    procedure ClearHtmlFile(): Boolean
    begin
    end;

    procedure ClearPngFiles() Succes: Boolean
    begin
    end;

    procedure ClearXmlAttachments()
    begin
    end;

    // procedure GetTiffFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetPdfFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetMiscFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetEmailFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetPngFile(var TempFile: Record "CDC Temp File" temporary; PageNo: Integer): Boolean
    // begin
    // end;

    // procedure GetXmlFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetCleanXmlFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetHtmlFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure GetXmlDoc(var XmlDoc: Codeunit "CSC XML Document"): Boolean
    // begin
    // end;

    // procedure GetVisualFile(var TempFile: Record "CDC Temp File"): Boolean
    // begin
    // end;

    // procedure SetTiffFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure SetPdfFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure SetMiscFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure SetEmailFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure SetXmlFile(var TempFile: Record "CDC Temp File" temporary; CreateHtmlStylesheet: Boolean) Result: Boolean
    // begin
    // end;

    // procedure SetCleanXmlFile(var TempFile: Record "CDC Temp File" temporary) Result: Boolean
    // begin
    // end;

    // procedure SetHtmlFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure SetPngFile(var TempFile: Record "CDC Temp File" temporary; PageNo: Integer): Boolean
    // begin
    // end;

    procedure CreateHtmlFile(Overwrite: Boolean): Boolean
    begin
    end;

    procedure GetEmailGUIDAsText(): Text[50]
    begin
    end;

    procedure CheckSourceTableFilter()
    begin
    end;

    procedure SetSourceID(KeyValues: Text[250])
    begin
    end;

    procedure GetSourceID(): Text[250]
    begin
    end;

    procedure SetManual(NewIsManual: Boolean)
    begin
    end;

    procedure GetDCSetup()
    begin
    end;

    procedure SetDCSetup(var NewDCSetup: Record "CDC Document Capture Setup")
    begin
    end;

    procedure SetCurrentCompany(NewCompanyName: Text[50])
    begin
    end;

    procedure ShowAttachedDocuments()
    begin
    end;

    procedure UpdateStatusText()
    begin
    end;

    procedure GetSourceTableNo(): Integer
    begin
    end;

    // procedure FindTemplateInCompanies(var FromCompany: Text[30]; var FromTemplate: Record "CDC Template"; SourceName: Text[250]): Boolean
    // begin
    // end;
    procedure SuspendDeleteCheck(Suspend: Boolean)
    begin
    end;

    procedure CheckOkToRegister()
    begin
    end;

    procedure BuildTempLinesTransLookup(var DocumentLine: Record "CDC Temp. Document Line"): Boolean
    begin
    end;

    // procedure BuildXmlBuffer(var XMLBuffer: Record "CDC XML Buffer" temporary): Boolean
    // begin
    // end;

    procedure OpenXmlViewer()
    begin
    end;

    procedure HasXmlAttachments(): Boolean
    begin
    end;

    procedure OpenXmlAttachments()
    begin
    end;

    procedure ResetSkipConfirmMsg()
    begin
    end;

    procedure LogDocumentUsageIfValid() IsLogged: Boolean
    begin
    end;

    procedure GetFileName(): Code[199]
    begin
        exit(Filename + "Filename 2");
    end;

    procedure SplitFileName(Filename: Text[199]; var FileName1: Text[100]; var Filename2: Text[99])
    begin
        FileName1 := CopyStr(Filename, 1, MaxStrLen(FileName1));
        Filename2 := CopyStr(Filename, MaxStrLen(FileName1) + 1, MaxStrLen(Filename2));
    end;

    procedure SetFileName(InputFilename: Text[199])
    begin
    end;

    procedure CanBeSplitOrMerged(): Boolean
    begin
    end;

    procedure DeletePngFiles()
    begin
    end;
}