table 6085575 "CDC Document Category"
{
    Caption = 'Document Category';
    DataCaptionFields = "Code", Description;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin

            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin

            end;
        }
        field(3; "Source Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            begin

                CheckSourceTable();
                if "Split on Sep. Fields" and ("Source Table No." > 0) then
                    "Split on Source ID" := true;
            end;
        }
        field(4; "Source Table Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("Source Table No.")));
            Caption = 'Source Table Name';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin

            end;
        }
        field(5; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Vendor,Contact,Customer,Job,Item,Fixed Asset,Employee';
            OptionMembers = " ",Vendor,Contact,Customer,Job,Item,"Fixed Asset",Employee;

            trigger OnValidate()
            begin

            end;
        }
        field(6; "Documents to Register"; Integer)
        {
            BlankZero = true;
            Caption = 'Documents to Register';
            Editable = false;

            trigger OnValidate()
            begin

            end;
        }
        field(10; "Registered Documents"; Integer)
        {
            BlankZero = true;
            Caption = 'Registered Documents';
            Editable = false;

            trigger OnValidate()
            begin

            end;
        }
        field(11; "Rejected Documents"; Integer)
        {
            BlankZero = true;
            Caption = 'Rejected Documents';
            Editable = false;

            trigger OnValidate()
            begin

            end;
        }
        field(12; "Export PDF File"; Option)
        {
            Caption = 'Export PDF File';
            InitValue = "Yes - Keep Existing Or Create New";
            OptionCaption = 'No,Yes - Keep Existing Or Create New,Yes - Always Create New';
            OptionMembers = No,"Yes - Keep Existing Or Create New","Yes - Always Create New";

            trigger OnValidate()
            begin

            end;
        }
        field(13; "Process Scanned Files"; Boolean)
        {
            Caption = 'Process Scanned Files';
            InitValue = true;

            trigger OnValidate()
            begin

            end;
        }
        field(14; "Process PDF Files"; Boolean)
        {
            Caption = 'Process PDF Files';
            InitValue = true;

            trigger OnValidate()
            begin

            end;
        }
        field(15; "PDF Format"; Option)
        {
            Caption = 'PDF Format';
            InitValue = "PDF/A";
            OptionCaption = 'PDF,PDF/A';
            OptionMembers = PDF,"PDF/A";

            trigger OnValidate()
            begin

            end;
        }
        field(16; "TIFF Image Resolution"; Integer)
        {
            Caption = 'TIFF Image Resolution';
            InitValue = 300;
            MinValue = 150;

            trigger OnValidate()
            begin

            end;
        }
        field(18; "Allow Deleting Documents"; Boolean)
        {
            Caption = 'Allow Deleting Documents';
        }
        field(21; "Document with UIC"; Option)
        {
            Caption = 'Doc. with Unidentified Company';
            OptionCaption = 'Import in active Company,Import as UIC document';
            OptionMembers = "Import in active Company","Import as UIC document";

            trigger OnValidate()
            begin

                TestField("Auto Move to Company", true);
            end;
        }
        field(22; "No. of Documents with UIC"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("CDC Document (UIC)" where("Document Category Code" = field(Code),
                                                            Status = const(Open)));
            Caption = 'Open UIC Documents';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin

            end;
        }
        field(25; "Drag and Drop Category"; Boolean)
        {
            Caption = 'Drag and Drop Category';
        }
        field(26; "Source Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Field No.';
        }
        field(27; "Source Field No. (Name)"; Integer)
        {
            BlankZero = true;
            Caption = 'Source Field No. (Name)';
        }
        field(29; "Destination Header Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Destination Header Table No.';
        }
        field(30; "Destination Line Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Destination Line Table No.';
        }
        field(31; "Import and Archive E-Mails"; Boolean)
        {
            Caption = 'Import and Archive Emails';
        }
        field(32; "Source Search Field No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Search Field No.';
        }
        field(33; "TIFF Image Colour Mode"; Option)
        {
            Caption = 'TIFF Image Colour Mode';
            OptionCaption = 'Black & White,Gray,Colour';
            OptionMembers = "Black & White",Gray,Colour;
        }
        field(39; "E-Mail Protocol"; Option)
        {
            Caption = 'Email Protocol';
            OptionCaption = 'IMAP,EWS';
            OptionMembers = IMAP,EWS;
        }
        field(40; "E-Mail Prefix (Cloud OCR)"; Text[10])
        {
            Caption = 'Email Prefix (Cloud OCR)';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
            begin

                DCSetup.Get();
                DCSetup.TestField("Use Cloud OCR");

            end;
        }
        field(41; "IMAP Server Address"; Text[250])
        {
            Caption = 'IMAP Server Address';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
            begin

                DCSetup.Get();
                DCSetup.TestField("Use Cloud OCR", false);
            end;
        }
        field(42; "IMAP Server Port"; Integer)
        {
            Caption = 'IMAP Server Port';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
            begin

                DCSetup.Get();
                DCSetup.TestField("Use Cloud OCR", false);
            end;
        }
        field(43; "IMAP Username"; Text[80])
        {
            Caption = 'IMAP Username';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
            begin

                DCSetup.Get();
                DCSetup.TestField("Use Cloud OCR", false);
            end;
        }
        field(44; "IMAP Password"; Text[50])
        {
            Caption = 'IMAP Password';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
            begin

                DCSetup.Get();
                DCSetup.TestField("Use Cloud OCR", false);
            end;
        }
        field(45; "IMAP Delete After Download"; Boolean)
        {
            Caption = 'Delete After Download';

            trigger OnValidate()
            begin

            end;
        }
        field(50; "Codeunit ID: Reopen"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Reopen';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));

            trigger OnValidate()
            begin

            end;
        }
        field(53; "Document Category GUID"; Guid)
        {
            Caption = 'Document Category GUID';

            trigger OnValidate()
            begin

            end;
        }
        field(55; "Register Documents Automatic."; Boolean)
        {
            Caption = 'Register Documents Automatically';
        }
        field(56; "Codeunit ID: Show Reg. Doc."; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Show Reg. Doc.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));

            trigger OnValidate()
            begin

            end;
        }
        field(58; "Codeunit ID: Get Doc. Status"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Get Doc. Status';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));

            trigger OnValidate()
            begin

            end;
        }
        field(60; "Documents for OCR"; Integer)
        {
            BlankZero = true;
            Caption = 'Documents for OCR';
            Editable = false;

            trigger OnValidate()
            begin

            end;
        }
        field(61; "Documents for Import"; Integer)
        {
            BlankZero = true;
            Caption = 'Documents for Import';
            Editable = false;

            trigger OnValidate()
            begin

            end;
        }
        field(62; "Documents with Error"; Integer)
        {
            BlankZero = true;
            Caption = 'Documents with Error';
            Editable = false;

            trigger OnValidate()
            begin

            end;
        }
        field(64; "Split on Barcode"; Boolean)
        {
            Caption = 'Split on Barcode';

            trigger OnValidate()
            begin

            end;
        }
        field(65; "Split Barcode Text"; Text[250])
        {
            Caption = 'Split on Barcode Text';

            trigger OnValidate()
            begin

            end;
        }
        field(66; "Split on Blank Page"; Boolean)
        {
            Caption = 'Split on Blank Page';

            trigger OnValidate()
            begin

            end;
        }
        field(67; "Split on Source ID"; Boolean)
        {
            Caption = 'Split on Source ID';
        }
        field(68; "Auto Move to Company"; Boolean)
        {
            Caption = 'Auto Move to Company';

            trigger OnValidate()
            begin

            end;
        }
        field(70; "Codeunit ID: Get File Count"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Get File Count';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));

            trigger OnValidate()
            begin

            end;
        }
        field(72; "Codeunit ID: Doc. or File"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Show Document or File';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));

            trigger OnValidate()
            begin

            end;
        }
        field(74; "Codeunit ID: Import Files"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Import Files';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));

            trigger OnValidate()
            begin

            end;
        }
        field(76; "Split on Sep. Fields"; Boolean)
        {
            Caption = 'Split on Separator Fields';

            trigger OnValidate()
            begin

                if "Source Table No." > 0 then
                    "Split on Source ID" := true;
            end;
        }
        field(78; "Max no. of Pages to Process"; Integer)
        {
            Caption = 'Max. number of pages to process per file';
            InitValue = 200;

            trigger OnValidate()
            begin

            end;
        }
        field(79; "OCR Export Codepage"; Integer)
        {
            Caption = 'OCR Export Codepage';
            InitValue = 1252;

            trigger OnValidate()
            begin

            end;
        }
        field(90; "Exported to Cloud OCR"; Boolean)
        {
            Caption = 'Exported to Cloud OCR';

            trigger OnValidate()
            begin

            end;
        }
        field(100; "EWS Client ID"; Text[36])
        {
            Caption = 'Client ID';
        }
        field(101; "EWS Tenant ID"; Text[36])
        {
            Caption = 'Tenant ID';
        }
        field(102; "EWS Client Secret"; Text[80])
        {
            Caption = 'Client Secret';
        }
        field(103; "EWS Certificate Thumbprint"; Text[40])
        {
            Caption = 'Certificate Thumbprint';
        }
        field(104; "EWS Mailbox Address"; Text[80])
        {
            Caption = 'Email Address';
        }
        field(110; "Process PDF with XML Files"; Boolean)
        {
            Caption = 'Process PDF files with XML files';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
            begin
                if not "Process PDF with XML Files" then
                    exit;

                DCSetup.Get();
                if not DCSetup."Use Cloud OCR" then
                    DCSetup.TestField("XML File Path");
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Source Table No.")
        {
        }
    }

    var
    procedure RegisterOpenDoc()
    var
        Document: Record "CDC Document";
    begin
        Document.SetCurrentKey(Status);
        Document.SetRange(Status, Document.Status::Open);
        Document.SetRange("Document Category Code", Code);

        if Document.FindSet() then
            repeat
                Document.Mark(true);
            until Document.Next() = 0;

        Document.FindFirst();
        Document.SetRange("Document Category Code");
        Document.MarkedOnly(true);
    end;

    procedure CheckSourceTable()
    begin
    end;

    procedure UpdateCounters()
    begin
    end;

    procedure GetCategoryPath(FileType: Option Obsolete,PDFForOCR,ImportFiles,ErrorFiles,ImportXmlFiles,CDNFiles) Path: Text[1024]
    begin
    end;

    procedure GetDragNDropCode(): Code[10]
    begin
    end;

    procedure UploadFilesForOCR()
    begin
    end;

    procedure UploadFilesForXML()
    begin
    end;


    procedure UploadFilesInFolderForOCR(FolderPath: Text[1024])
    begin
    end;

    procedure OpenFilesForOCR()
    begin
    end;

    procedure OpenFilesForImport()
    begin
    end;

    procedure OpenFilesWithError()
    begin
    end;

    procedure OpenOpenDocuments()
    begin
    end;

    procedure OpenRegisteredDocuments()
    begin
    end;

    procedure OpenRejectedDocuments()
    begin
    end;

    procedure OpenUICDocuments()
    begin
    end;

    procedure HasMasterTemplate(): Boolean
    begin
    end;

    procedure IsPurchInvCrMemoCategory(): Boolean
    begin
    end;

    procedure GetEmail(): Text[250]
    begin
    end;

    procedure GetCodeForCloudEMail() NewEMailCode: Code[20]
    begin
    end;

    procedure CalculateSplitDocsAuto(): Boolean
    begin
    end;

    procedure OnValidateSplitDocsAuto(SplitDocsAutomatically: Boolean)
    begin
    end;

    procedure Curlies(): Text[2]
    begin
    end;

    procedure IsValidGuid(Guid: Text[50]): Boolean
    begin
    end;
}