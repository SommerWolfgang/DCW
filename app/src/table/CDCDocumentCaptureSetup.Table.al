table 6085573 "CDC Document Capture Setup"
{
    Caption = 'Document Capture Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(2; "Document Nos."; Code[20])
        {
            Caption = 'Document Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Template Nos."; Code[20])
        {
            Caption = 'Template Nos.';
            TableRelation = "No. Series";
        }
        field(6; "File Path for OCR-proc. files"; Text[200])
        {
            Caption = 'File Path for OCR-processed files';

            trigger OnValidate()
            begin
                AddFolderSlash("File Path for OCR-proc. files");
            end;
        }
        field(7; "PDF File Path for OCR"; Text[200])
        {
            Caption = 'PDF File Path for OCR';

            trigger OnValidate()
            begin
                AddFolderSlash("PDF File Path for OCR");
            end;
        }
        field(8; "Unidentified Company File Path"; Text[200])
        {
            Caption = 'Unidentified Company File Path';

            trigger OnValidate()
            begin
                AddFolderSlash("Unidentified Company File Path");
            end;
        }
        field(9; "Fill-out LCY"; Boolean)
        {
            Caption = 'Fill-out LCY';
        }
        field(11; "Archive File Path"; Text[200])
        {
            Caption = 'Archive File Path';

            trigger OnValidate()
            begin
                AddFolderSlash("Archive File Path");
                IsFilePathUniqueCrossComp("Archive File Path");
            end;
        }
        field(14; "Disk File Directory Structure"; Option)
        {
            Caption = 'Disk File Directory Structure';
            OptionCaption = 'One Directory,Year\Month,Year\Month\Day';
            OptionMembers = "One Directory","Year\Month","Year\Month\Day";

            trigger OnValidate()
            begin
                if "Disk File Directory Structure" <> xRec."Disk File Directory Structure" then
                    MoveDocFilesToNewStorageSetup(FieldCaption("Disk File Directory Structure"));
            end;
        }
        field(15; "Miscellaneous File Path"; Text[200])
        {
            Caption = 'Miscellaneous File Path';

            trigger OnValidate()
            begin
                AddFolderSlash("Miscellaneous File Path");
                IsFilePathUniqueCrossComp("Miscellaneous File Path");
            end;
        }
        field(17; "Export Local OCR Config."; Boolean)
        {
            Caption = 'Export Local OCR Configuration';
            InitValue = true;
        }
        field(18; "Export Remote OCR Config."; Boolean)
        {
            Caption = 'Export Remote OCR Configuration';
        }
        field(19; "Remote OCR Config. Path"; Text[200])
        {
            Caption = 'Remote OCR Config. Path';

            trigger OnValidate()
            begin
                AddFolderSlash("Remote OCR Config. Path");
            end;
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(23; "Document Storage Type"; Option)
        {
            Caption = 'Document Storage Type';
            OptionCaption = 'File System,Database,Azure Blob Storage';
            OptionMembers = "File System",Database,"Azure Blob Storage";
        }
        field(30; "SMTP Require SSL/TLS"; Boolean)
        {
            Caption = 'SMTP require SSL/TLS';
        }
        field(31; "Sender E-mail"; Text[80])
        {
            Caption = 'Sender Email';
        }
        field(32; "Sender Name"; Text[50])
        {
            Caption = 'Sender Name';
        }
        field(40; "Scanner Driver Type"; Option)
        {
            Caption = 'Scanner Driver Type';
            OptionCaption = 'None,Isis,Twain';
            OptionMembers = "None",Isis,Twain;
        }
        field(41; "Sign Scanned Documents"; Boolean)
        {
            Caption = 'Sign Scanned Documents';
        }
        field(43; "PDF Signature Certificate"; BLOB)
        {
            Caption = 'PDF Signature Certificate';
        }
        field(44; "PDF Signature Cert. Password"; Text[30])
        {
            Caption = 'PDF Signature Certificate Password';
        }
        field(64; Delimiters; Text[250])
        {
            Caption = 'Delimiters';
        }
        field(68; "Data Version"; Integer)
        {
            Caption = 'Data Version';
        }
        field(70; "Azure Storage Account Name"; Text[50])
        {
            Caption = 'Storage Account Name';
        }
        field(71; "Azure Storage Account Key"; Text[100])
        {
            Caption = 'Storage Account Key';
        }
        field(72; "Azure Blob Container Name"; Text[50])
        {
            Caption = 'Blob Container Name';

            trigger OnValidate()
            begin
                if xRec."Azure Blob Container Name" <> "Azure Blob Container Name" then
                    MoveDocFilesToNewStorageSetup(FieldCaption("Azure Blob Container Name"));
            end;
        }
        field(81; "Web: Dimension 1 Code (Header)"; Code[20])
        {
            Caption = 'Web Dimension 1 Code (Header)';
            TableRelation = Dimension;
        }
        field(82; "Web: Dimension 2 Code (Header)"; Code[20])
        {
            Caption = 'Web Dimension 2 Code (Header)';
            TableRelation = Dimension;
        }
        field(83; "Web: Dimension 3 Code (Header)"; Code[20])
        {
            Caption = 'Web Dimension 3 Code (Header)';
            TableRelation = Dimension;
        }
        field(84; "Web: Dimension 4 Code (Header)"; Code[20])
        {
            Caption = 'Web Dimension 4 Code (Header)';
            TableRelation = Dimension;
        }
        field(85; "Web: Dimension 5 Code (Header)"; Code[20])
        {
            Caption = 'Web Dimension 5 Code (Header)';
            TableRelation = Dimension;
        }
        field(86; "Web: Dimension 6 Code (Header)"; Code[20])
        {
            Caption = 'Web Dimension 6 Code (Header)';
            TableRelation = Dimension;
        }
        field(87; "Web: Dimension 7 Code (Header)"; Code[20])
        {
            Caption = 'Web Dimension 7 Code (Header)';
            TableRelation = Dimension;
        }
        field(88; "Web: Dimension 8 Code (Header)"; Code[20])
        {
            Caption = 'Web Dimension 8 Code (Header)';
            TableRelation = Dimension;
        }
        field(89; "Web: Dimension 1 Code (Lines)"; Code[20])
        {
            Caption = 'Web Dimension 1 Code (Lines)';
            TableRelation = Dimension;
        }
        field(90; "Web: Dimension 2 Code (Lines)"; Code[20])
        {
            Caption = 'Web Dimension 2 Code (Lines)';
            TableRelation = Dimension;
        }
        field(91; "Web: Dimension 3 Code (Lines)"; Code[20])
        {
            Caption = 'Web Dimension 3 Code (Lines)';
            TableRelation = Dimension;
        }
        field(92; "Web: Dimension 4 Code (Lines)"; Code[20])
        {
            Caption = 'Web Dimension 4 Code (Lines)';
            TableRelation = Dimension;
        }
        field(93; "Web: Dimension 5 Code (Lines)"; Code[20])
        {
            Caption = 'Web Dimension 5 Code (Lines)';
            TableRelation = Dimension;
        }
        field(94; "Web: Dimension 6 Code (Lines)"; Code[20])
        {
            Caption = 'Web Dimension 6 Code (Lines)';
            TableRelation = Dimension;
        }
        field(95; "Web: Dimension 7 Code (Lines)"; Code[20])
        {
            Caption = 'Web Dimension 7 Code (Lines)';
            TableRelation = Dimension;
        }
        field(96; "Web: Dimension 8 Code (Lines)"; Code[20])
        {
            Caption = 'Web Dimension 8 Code (Lines)';
            TableRelation = Dimension;
        }
        field(97; "Web: Show Job No."; Boolean)
        {
            Caption = 'Show Job No.';
        }
        field(98; "Web: Show Job Task No."; Boolean)
        {
            Caption = 'Show Job Task No.';
        }
        field(99; "Web: Show VAT Prod. Group"; Boolean)
        {
            Caption = 'Show VAT Prod. Group';
        }
        field(100; "Purch: Use TIFF-Form for Appr."; Boolean)
        {
            Caption = 'Use TIFF-Form for Approval';
        }
        field(101; "Purch: No. of Open PIs"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Invoice),
                                                         Status = const(Open)));
            Caption = 'No. of Open Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Purch: No. of Released PIs"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Invoice),
                                                         Status = const(Released)));
            Caption = 'No. of Released Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(103; "Purch: No. of PIs for Approval"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Invoice),
                                                         Status = const("Pending Approval")));
            Caption = 'No. of Invoices for Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; "Purch: No. of Overdue PIs"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Invoice),
                                                         "Due Date" = field("Date Filter")));
            Caption = 'No. of Overdue Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Purch: No. of Open PCs"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const("Credit Memo"),
                                                         Status = const(Open)));
            Caption = 'No. of Open Credit Memoes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(111; "Purch: No. of Released PCs"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const("Credit Memo"),
                                                         Status = const(Released)));
            Caption = 'No. of Released PCM';
            Editable = false;
            FieldClass = FlowField;
        }
        field(112; "Purch: No. of PCs for Approval"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const("Credit Memo"),
                                                         Status = const("Pending Approval")));
            Caption = 'No. of Credit Memoes for Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(119; "Purch: No. of Overdue Ap. Ent."; Integer)
        {
            CalcFormula = count("Approval Entry" where("Table ID" = const(38),
                                                        "Document Type" = filter(Invoice | "Credit Memo"),
                                                        Status = filter(Created | Open),
                                                        "Due Date" = field("Date Filter")));
            Caption = 'No. of Overdue Approval Entries';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Purch: Last Status E-Mail Sent"; Date)
        {
            CalcFormula = max("CDC Event Register"."Creation Date" where(Area = const("Purch. Approval Status E-mail")));
            Caption = 'Last Status Email Sent';
            Editable = false;
            FieldClass = FlowField;
        }
        field(121; "Purch: 4-eyes Approval"; Option)
        {
            Caption = '4-eyes Approval';
            OptionCaption = 'Not Required,Required,Required - both with full amounts limits';
            OptionMembers = "Not Required",Required,"Required - both with full amounts limits";
        }
        field(122; "Purch: Approval Template"; BLOB)
        {
            Caption = 'Approval Template';
            SubType = UserDefined;
        }
        field(123; "Purch: Approval E-Mail Subject"; Text[80])
        {
            Caption = 'Approval Email Subject';
        }
        field(124; "Check Amounts on Approval"; Option)
        {
            Caption = 'Check Amounts on Approval';
            OptionCaption = 'No,Every Approval,Last Approval';
            OptionMembers = No,"Every Approval","Last Approval";
        }
        field(126; "Purch: Amount Valid. on Post."; Option)
        {
            Caption = 'Amount Validation on Post';
            OptionCaption = 'Not Required,Amount Excl. VAT and Amount Incl. VAT must match imported amounts,Only Amount Incl. VAT must match imported amounts,Only Amount Excl. VAT must match imported amounts';
            OptionMembers = "Not Required","Amount Excl. VAT and Amount Incl. VAT must match imported amounts","Only Amount Incl. VAT must match imported amounts","Only Amount Excl. VAT must match imported amounts";
        }
        field(127; "Purch: Allow Force Approval"; Boolean)
        {
            Caption = 'Allow Force Approval';
        }
        field(128; "Purch: 4-eyes, 2nd Approver"; Option)
        {
            Caption = '4-eyes Approval, 2nd Approver';
            DataClassification = EndUserIdentifiableInformation;
            OptionCaption = 'Manual selection,Automatic selection';
            OptionMembers = "Manuel selection","Automatic selection";
        }
        field(130; "Purch. Allocation Nos."; Code[20])
        {
            Caption = 'Purchase Allocation Nos.';
            TableRelation = "No. Series";
        }
        field(131; "Enable Purchase Allocation"; Boolean)
        {
            Caption = 'Enable Purchase Allocation';
        }
        field(132; "Auto. Post Purch. Allocation"; Boolean)
        {
            Caption = 'Auto. Post Purchase Allocation';
        }
        field(133; "Purch. Alloc. G/L Account Type"; Option)
        {
            Caption = 'Purchase Allocation G/L Account Type';
            OptionCaption = 'Use Posting Setup,Use Account on Purchase Lines';
            OptionMembers = "Use Posting Setup","Use Account on Purchase Lines";
        }
        field(134; "Purch. Alloc. Source Code"; Code[10])
        {
            Caption = 'Purchase Allocation Source Code';
            TableRelation = "Source Code";
        }
        field(135; "Purch. Alloc. Amounts to Use"; Option)
        {
            Caption = 'Purchase Allocation Amounts to Use';
            OptionCaption = 'Use Lines or Imported Amounts,Always use Imported Amounts';
            OptionMembers = "Use Lines or Imported Amounts","Always use Imported Amounts";

            trigger OnValidate()
            begin
                if "Purch. Alloc. Amounts to Use" = "Purch. Alloc. Amounts to Use"::"Always use Imported Amounts" then
                    Validate("Purch. Alloc. G/L Account Type", "Purch. Alloc. G/L Account Type"::"Use Posting Setup");
            end;
        }
        field(137; "Check Dim. Submit for Approval"; Boolean)
        {
            Caption = 'Check Dimensions on Submit for Approval';
        }
        field(138; "Rev. Purch.Alloc. Posting Date"; Option)
        {
            Caption = 'Reversed Purch. Alloc. Posting Date';
            OptionCaption = 'Original purch. allocation posting date,Invoice/cr. memo posting date';
            OptionMembers = "Original purch. allocation posting date","Invoice/cr. memo posting date";
        }
        field(139; "Check Dimensions on Approval"; Option)
        {
            Caption = 'Check Dimensions on Approval';
            OptionCaption = 'No,Every Approval,Last Approval';
            OptionMembers = No,"Every Approval","Last Approval";
        }
        field(140; "Web: Show Description 2"; Boolean)
        {
            Caption = 'Show Description 2';
        }
        field(141; "Web: Show Line Discount Pct."; Boolean)
        {
            Caption = 'Show Line Discount Pct.';
        }
        field(142; "Web: Show Prod. Posting Group"; Boolean)
        {
            Caption = 'Show Prod. Posting Group';
        }
        field(143; "Maintain User Document Search"; Boolean)
        {
            Caption = 'Maintain User Specific Doc. Search';
        }
        field(144; "Web: Show Posting Account Name"; Boolean)
        {
            Caption = 'Show Posting Account Name';
        }
        field(145; "Web: Dim. & Job Field Place."; Option)
        {
            Caption = 'Dimension && Job Fields Placement';
            OptionCaption = 'Before Quantity,After Amount';
            OptionMembers = "Before Quantity","After Amount";
        }
        field(146; "Web: Show Unit of Measure"; Boolean)
        {
            Caption = 'Show Unit of Measure';
        }
        field(147; "Web: Show Type"; Boolean)
        {
            Caption = 'Show Type';
        }
        field(148; "Web: Show Amounts in LCY"; Option)
        {
            Caption = 'Show Amounts in LCY';
            OptionCaption = 'Never,Always,If different from purchase currency';
            OptionMembers = Never,Always,"If different from purchase currency";
        }
        field(149; "Web: Historical Documents"; Option)
        {
            Caption = 'Show in Historical Documents';
            OptionCaption = 'Only Posted Documents,Posted and Un-posted Documents';
            OptionMembers = "Only Posted Documents","Posted and Un-posted Documents";
        }
        field(150; "Error E-Mail"; Text[80])
        {
            Caption = 'Error Email';
        }
        field(153; "Dynamics NAV Server Tenant"; Text[50])
        {
            Caption = 'Dynamics NAV Server Tenant';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            DCSetup.ChangeCompany(Company.Name);
                            if DCSetup.Get() then begin
                                DCSetup."Dynamics NAV Server Tenant" := "Dynamics NAV Server Tenant";
                                DCSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(154; "Dynamics NAV Server Name"; Text[50])
        {
            Caption = 'Dynamics NAV Server Name';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            DCSetup.ChangeCompany(Company.Name);
                            if DCSetup.Get() then begin
                                DCSetup."Dynamics NAV Server Name" := "Dynamics NAV Server Name";
                                DCSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(155; "Dynamics NAV Server Instance"; Text[50])
        {
            Caption = 'Dynamics NAV Server Instance';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            DCSetup.ChangeCompany(Company.Name);
                            if DCSetup.Get() then begin
                                DCSetup."Dynamics NAV Server Instance" := "Dynamics NAV Server Instance";
                                DCSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(156; "Dynamics NAV Server Port"; Integer)
        {
            Caption = 'Dynamics NAV Server Port';
            MinValue = 0;

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            DCSetup.ChangeCompany(Company.Name);
                            if DCSetup.Get() then begin
                                DCSetup."Dynamics NAV Server Port" := "Dynamics NAV Server Port";
                                DCSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(157; "Purch: Approval NAV Client"; Option)
        {
            Caption = 'Approval NAV Client';
            OptionCaption = 'Classic,RoleTailored';
            OptionMembers = Classic,RoleTailored;

            trigger OnValidate()
            begin
                if "Purch: Approval NAV Client" = "Purch: Approval NAV Client"::RoleTailored then begin
                    TestField("Dynamics NAV Server Name");
                    TestField("Dynamics NAV Server Port");
                    TestField("Dynamics NAV Server Instance");
                end;
            end;
        }
        field(158; "Barcode Nos."; Code[20])
        {
            Caption = 'Barcode Nos.';
            TableRelation = "No. Series";
        }
        field(159; "Web: Show FA Posting Type"; Boolean)
        {
            Caption = 'Show FA Posting Type';
        }
        field(160; "Security Certificate"; BLOB)
        {
            Caption = 'Security Certificate';
        }
        field(161; "Dynamics NAV Web Server Name"; Text[50])
        {
            Caption = 'Dynamics NAV Web Server Name';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            DCSetup.ChangeCompany(Company.Name);
                            if DCSetup.Get() then begin
                                DCSetup."Dynamics NAV Web Server Name" := "Dynamics NAV Web Server Name";
                                DCSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(162; "Dynamics NAV Web Server Port"; Integer)
        {
            Caption = 'Dynamics NAV Web Server Port';
            MinValue = 0;

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            DCSetup.ChangeCompany(Company.Name);
                            if DCSetup.Get() then begin
                                DCSetup."Dynamics NAV Web Server Port" := "Dynamics NAV Web Server Port";
                                DCSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(163; "Dynamics NAV Web Server Inst."; Text[50])
        {
            Caption = 'Dynamics NAV Web Server Instance';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            DCSetup.ChangeCompany(Company.Name);
                            if DCSetup.Get() then begin
                                DCSetup."Dynamics NAV Web Server Inst." := "Dynamics NAV Web Server Inst.";
                                DCSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(164; "Dynamics NAV Web Server Tenant"; Text[50])
        {
            Caption = 'Dynamics NAV Web Server Tenant';

            trigger OnValidate()
            var
                DCSetup: Record "CDC Document Capture Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            DCSetup.ChangeCompany(Company.Name);
                            if DCSetup.Get() then begin
                                DCSetup."Dynamics NAV Web Server Tenant" := "Dynamics NAV Web Server Tenant";
                                DCSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(165; "Dynamics NAV Web Server SSL"; Boolean)
        {
            Caption = 'Use Dynamics NAV Web Server With SSL';
        }
        field(170; "Codeunit ID: Record ID Lookup"; Integer)
        {
            BlankZero = true;
            Caption = 'Codeunit ID: Record ID Lookup';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Codeunit));
        }
        field(171; "Company Code in Archive"; Boolean)
        {
            Caption = 'Include Company Code in Archive paths';

            trigger OnValidate()
            begin
                if "Company Code in Archive" <> xRec."Company Code in Archive" then begin
                    VerifyFilePathsCrossComp();
                    MoveDocFilesToNewStorageSetup(FieldCaption("Company Code in Archive"));
                end;
            end;
        }
        field(172; "Use Cloud OCR"; Boolean)
        {
            Caption = 'Use Cloud OCR';
        }
        field(173; "Cloud OCR Cache Timeout"; Integer)
        {
            Caption = 'Cloud OCR Cache Timeout';
        }
        field(174; "Category Code in Archive"; Boolean)
        {
            Caption = 'Include Category Code in Archive paths';

            trigger OnValidate()
            begin
                if "Category Code in Archive" <> xRec."Category Code in Archive" then
                    MoveDocFilesToNewStorageSetup(FieldCaption("Category Code in Archive"));
            end;
        }
        field(179; "Use Acc. and Dim. App. Pms."; Boolean)
        {
            Caption = 'Use Account and Dimension Approval Permissions';
        }
        field(180; "Use UIC Documents"; Boolean)
        {
            Caption = 'Use Unidentified Company Documents';
        }
        field(190; "Allow Forward and Approve"; Boolean)
        {
            Caption = 'Allow Forward and Approve';
            InitValue = true;
        }
        field(191; "Allow Forward w/o Approv."; Boolean)
        {
            Caption = 'Allow Forward w/o Approval';
            InitValue = true;
        }
        field(192; "Allow Forward and Return"; Boolean)
        {
            Caption = 'Allow Forward and return for Approval';
            InitValue = true;
        }
        field(193; "Web: Show Deferral Code"; Boolean)
        {
            Caption = 'Show Deferral Code';
        }
        field(194; "Web: Show Location Code"; Boolean)
        {
            Caption = 'Show Location Code';
        }
        field(195; "Web: Show IC Fields"; Boolean)
        {
            Caption = 'Show Intercompany Fields';
        }
        field(200; "XML File Path"; Text[200])
        {
            Caption = 'XML File Path';

            trigger OnValidate()
            begin
                AddFolderSlash("XML File Path");
            end;
        }
        field(201; "Show Std. Purch. UI Elements"; Boolean)
        {
            Caption = 'Show Standard Purchase UI Elements';
        }
        field(204; "Enable New Rule Validation"; Boolean)
        {
            Caption = 'Enable New Rule Validation';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure DrillDownPurchHeader(Type: Integer; Status: Integer)
    begin
    end;

    procedure DrillDownOverdueApprEntries()
    var
        ApprovalEntry: Record "Approval Entry";
        PurchHeader: Record "Purchase Header";
    begin
        ApprovalEntry.FilterGroup(2);
        ApprovalEntry.SetRange("Table ID", DATABASE::"Purchase Header");
        ApprovalEntry.SetFilter("Document Type", '%1|%2', ApprovalEntry."Document Type"::Invoice,
          ApprovalEntry."Document Type"::"Credit Memo");
        ApprovalEntry.SetFilter(Status, '%1|%2', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open);
        ApprovalEntry.SetFilter("Due Date", GetFilter("Date Filter"));
        ApprovalEntry.FilterGroup(0);
    end;


    procedure DrillDownOverduePI()
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetFilter("Due Date", GetFilter("Date Filter"));
        PAGE.Run(0, PurchHeader);
    end;


    procedure ShowMoveDocFilesConfirmation(DCSetup: Record "CDC Document Capture Setup"; xDCSetup: Record "CDC Document Capture Setup"; CaptionFieldChanged: Text[100])
    begin
    end;

    procedure MoveDocFilesToNewStorageSetup(CaptionFieldChanged: Text[100])
    begin
    end;

    procedure CopyDocFilesToNewStorageSetup(Document: Record "CDC Document")
    begin
    end;

    procedure CopyUICFilesToNewStorageSetup(Document: Record "CDC Document (UIC)")
    begin
    end;

    procedure ClearDocFiles(var Document: Record "CDC Document")
    begin
    end;

    procedure ClearUICDocFiles(var DocumentUIC: Record "CDC Document (UIC)")
    begin
    end;

    procedure ExportDocumentCategories()
    begin
    end;

    procedure FormatText(TheText: Text[250]) NewText: Text[250]
    begin
    end;

    procedure SetHideValidate(NewHideValidation: Boolean)
    begin
    end;

    procedure SetHideStorageOptions(NewHideStorageOptions: Boolean)
    begin
    end;

    procedure AddFolderSlash(var FolderPath: Text[200])
    begin
    end;

    procedure IsFilePathUniqueCrossComp(FilePath: Text[200])
    begin
    end;

    procedure VerifyFilePathsCrossComp()
    begin
    end;

    procedure GetStorageLocation(var DCSetup: Record "CDC Document Capture Setup") Location: Text[1024]
    begin
    end;

    procedure IsUICSetupConsistent(ThrowError: Boolean): Boolean
    begin
    end;

    procedure UpdateStorageSettings() Updated: Boolean
    begin
    end;

    procedure SetCurrentCompany(Company: Text[50])
    begin
    end;

    procedure SetMigrationOptions(NewHideDialog: Boolean; NewMigrationMethod: Option ,"Job Queue",Now)
    begin
    end;

    procedure IsUICActiveInOtherCompanies(): Boolean
    begin
    end;
}