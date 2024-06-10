table 6086300 "CEM Expense Management Setup"
{
    Caption = 'Expense Management Setup';
    Permissions = TableData "CDC Continia User Setup" = r,
                  TableData "CEM Expense User Group" = r,
                  TableData "CEM Field Translation" = r;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Company Logo"; BLOB)
        {
            Caption = 'Company Logo';
            SubType = Bitmap;
        }
        field(20; "Archive Directory Structure"; Option)
        {
            Caption = 'Archive Directory Structure';
            OptionCaption = 'One Directory,Year\Month,Year\Month\Day';
            OptionMembers = "One Directory","Year\Month","Year\Month\Day";

            trigger OnValidate()
            begin
                if "Archive Directory Structure" <> xRec."Archive Directory Structure" then
                    if "Document Storage Type" = "Document Storage Type"::"File System" then
                        MoveDocFilesToNewStorageSetup(FieldCaption("Archive Directory Structure"));
            end;
        }
        field(21; "Archive Path"; Text[250])
        {
            Caption = 'Archive Path';

            trigger OnValidate()
            var
                FileSysMgt: Codeunit "CDC File System Management";
            begin
                if "Archive Path" <> xRec."Archive Path" then
                    if "Document Storage Type" = "Document Storage Type"::"File System" then begin
                        if not FileSysMgt.DirectoryExists("Archive Path") then
                            if not FileSysMgt.CreateDirectory("Archive Path") then
                                Error(LocationNotFoundErr, "Archive Path");

                        MoveDocFilesToNewStorageSetup(FieldCaption("Archive Path"));
                    end;
            end;
        }
        field(22; "Company Code in Archive"; Boolean)
        {
            Caption = 'Company Code in Archive';

            trigger OnValidate()
            begin
                if xRec."Company Code in Archive" <> "Company Code in Archive" then
                    if "Document Storage Type" = "Document Storage Type"::"File System" then
                        MoveDocFilesToNewStorageSetup(FieldCaption("Company Code in Archive"));
            end;
        }
        field(24; "Document Storage Type"; Option)
        {
            Caption = 'Document Storage Type';
            OptionCaption = 'File System,Database,Azure Blob Storage';
            OptionMembers = "File System",Database,"Azure Blob Storage";

            trigger OnValidate()
            var
                PlatformTargetMgt: Codeunit "CDC Platform Target Management";
                SaaSMgt: Codeunit "CDC SaaS Management";
            begin
                if not PlatformTargetMgt.IsOnPremInstalled and ("Document Storage Type" = "Document Storage Type"::"File System") then
                    Error(OnPremAppNotInstalled);

                if SaaSMgt.SoftwareAsAService and ("Document Storage Type" = "Document Storage Type"::"File System") then
                    "Document Storage Type" := "Document Storage Type"::Database;

                if "Document Storage Type" <> xRec."Document Storage Type" then
                    MoveDocFilesToNewStorageSetup(FieldCaption("Document Storage Type"));
            end;
        }
        field(25; "Welcome E-Mails"; Option)
        {
            Caption = 'Welcome E-Mails';
            OptionCaption = 'Send automatically,Send manually';
            OptionMembers = "Send automatically","Send manually";
        }
        field(26; "Web: Show Prod. Posting Group"; Boolean)
        {
            Caption = 'Show Prod. Posting Group';
        }
        field(27; "Web: Show VAT Prod. Group"; Boolean)
        {
            Caption = 'Show VAT Prod. Posting Group';
        }
        field(28; "Web: Show Bus. Posting Group"; Boolean)
        {
            Caption = 'Show Bus. Posting Group';
        }
        field(29; "Web: Show VAT Bus. Group"; Boolean)
        {
            Caption = 'Show VAT Bus. Posting Group';
        }
        field(30; "Web: Show Description 2"; Boolean)
        {
            Caption = 'Show Description 2';
        }
        field(31; "Web: Show Amounts Only in LCY"; Boolean)
        {
            Caption = 'Show Amounts Only in LCY';
        }
        field(32; "Web: Show Posting Account"; Boolean)
        {
            Caption = 'Show Posting Account';
        }
        field(33; "Web: Enable Allocations"; Boolean)
        {
            Caption = 'Enable Allocations for Full Users';
        }
        field(34; "User Paid Credit Card"; Boolean)
        {
            Caption = 'Private Invoiced';
        }
        field(35; "Ask User Paid Credit Card"; Boolean)
        {
            Caption = 'Enable Private Invoiced';
        }
        field(40; "Digital Sign Attachments"; Boolean)
        {
            Caption = 'Digital Sign Attachments';
        }
        field(41; "Azure Storage Account Name"; Text[50])
        {
            Caption = 'Storage Account Name';
        }
        field(42; "Azure Storage Account Key"; Text[100])
        {
            Caption = 'Storage Account Key';
        }
        field(43; "Azure Blob Container Name"; Text[50])
        {
            Caption = 'Blob Container Name';

            trigger OnValidate()
            begin
                if xRec."Azure Blob Container Name" <> "Azure Blob Container Name" then
                    MoveDocFilesToNewStorageSetup(FieldCaption("Azure Blob Container Name"));
            end;
        }
        field(60; "Create Expense w. Transaction"; Boolean)
        {
            Caption = 'Create Expense from Transaction';
        }
        field(61; "Send Status E-mail at Creation"; Boolean)
        {
            Caption = 'Send Status E-mail when Expense is created';
        }
        field(66; "Limited Role ID"; Code[20])
        {
            Caption = 'Limited Role ID';
            Description = 'To be deleted';
            TableRelation = "Permission Set";
        }
        field(71; "Send Release to App"; Boolean)
        {
            Caption = 'Send Release to App';
        }
        field(72; "Release Notification Method"; Option)
        {
            Description = 'To be deleted';
            OptionCaption = ' ,Instantly,Scheduled';
            OptionMembers = " ",Instantly,Scheduled;
        }
        field(73; "Release Notification Method2"; Option)
        {
            Caption = 'Release Notification Method';
            OptionCaption = 'Never,Instantly,Scheduled';
            OptionMembers = Never,Instantly,Scheduled;
        }
        field(75; "Settlement Pre-approval"; Option)
        {
            Caption = 'Settlement Pre-approval';
            OptionCaption = 'Disabled,Optional,Mandatory';
            OptionMembers = Disabled,Optional,Mandatory;

            trigger OnValidate()
            begin
                ConfigurePreApprovalFields;
            end;
        }
        field(80; "Posting Description"; Text[30])
        {
            Caption = 'Posting Description';
        }
        field(81; "Invoice Posting Description"; Text[30])
        {
            Caption = 'Invoice Posting Description';
        }
        field(82; "Settlement Posting Description"; Text[30])
        {
            Caption = 'Settlement Posting Description';
        }
        field(90; "Maximum Matching Diff. Pct."; Decimal)
        {
            Caption = 'Maximum Matching Difference in %';
            DecimalPlaces = 0 : 2;
        }
        field(100; "Default Web/App Language"; Code[10])
        {
            Caption = 'Corporate Language';
            TableRelation = Language;

            trigger OnValidate()
            begin
                if "Default Web/App Language" <> xRec."Default Web/App Language" then
                    "Force Field Update in CO" := true;
            end;
        }
        field(110; "Card Transaction Bal. Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,,Vendor,Bank Account';
            OptionMembers = "G/L Account",,Vendor,"Bank Account";

            trigger OnValidate()
            var
                UserCreditCard: Record "CEM Continia User Credit Card";
            begin
                if "Card Transaction Bal. Type" = "Card Transaction Bal. Type"::Vendor then
                    TestField("Expense Posting", "Expense Posting"::"Preferable Purchase Invoice");

                if "Card Transaction Bal. Type" <> xRec."Card Transaction Bal. Type" then begin
                    UserCreditCard.SetRange("Account Type", xRec."Card Transaction Bal. Type");
                    UserCreditCard.SetRange("Account No.", xRec."Card Transaction Bal. No.");
                    if UserCreditCard.FindFirst then
                        Message(BeAwareExistingCardsTxt, UserCreditCard.TableCaption,
                          UserCreditCard.FieldCaption("Account Type"), UserCreditCard."Account Type",
                          UserCreditCard.FieldCaption("Account No."), UserCreditCard."Account No.");
                    "Card Transaction Bal. No." := '';
                end;
            end;
        }
        field(115; "Card Transaction Bal. No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Card Transaction Bal. Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Card Transaction Bal. Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Card Transaction Bal. Type" = CONST(Vendor)) Vendor;

            trigger OnValidate()
            var
                UserCreditCard: Record "CEM Continia User Credit Card";
            begin
                if ("Card Transaction Bal. No." <> '') and
                   ("Card Transaction Bal. No." <> xRec."Card Transaction Bal. No.")
                then begin
                    UserCreditCard.SetRange("Account Type", xRec."Card Transaction Bal. Type");
                    UserCreditCard.SetRange("Account No.", xRec."Card Transaction Bal. No.");
                    if UserCreditCard.FindFirst then
                        Message(BeAwareExistingCardsTxt, UserCreditCard.TableCaption,
                          UserCreditCard.FieldCaption("Account Type"), UserCreditCard."Account Type",
                          UserCreditCard.FieldCaption("Account No."), UserCreditCard."Account No.");
                end;
            end;
        }
        field(116; "Intermediate Expense Account"; Code[20])
        {
            Caption = 'Intermediate Account';
            TableRelation = "G/L Account";
        }
        field(117; "Expense Posting"; Option)
        {
            Caption = 'Expense Posting';
            OptionCaption = 'Use General Journal,Preferable Purchase Invoice';
            OptionMembers = "Use General Journal","Preferable Purchase Invoice";

            trigger OnValidate()
            var
                UserCreditCard: Record "CEM Continia User Credit Card";
                Expense: Record "CEM Expense";
                EMSetup: Record "CEM Expense Management Setup";
                ExpensePostingSetup: Record "CEM Posting Setup";
            begin
                if xRec."Expense Posting" = "Expense Posting" then
                    exit;

                if "Expense Posting" = "Expense Posting"::"Use General Journal" then begin
                    EMSetup."Expense Posting" := "Expense Posting"::"Preferable Purchase Invoice";
                    UserCreditCard.SetRange("Account Type", UserCreditCard."Account Type"::Vendor);
                    if UserCreditCard.FindFirst then
                        Error(CreditCardVendorNotallowedErr,
                          UserCreditCard."Card No.", UserCreditCard."Continia User ID", UserCreditCard."Account Type",
                            FieldCaption("Expense Posting"), EMSetup."Expense Posting");
                    ExpensePostingSetup.SetRange("Posting Account Type", ExpensePostingSetup."Posting Account Type"::Item);
                    if ExpensePostingSetup.FindFirst then
                        Error(ItemPostingInPSNotAllowedErr, "Expense Posting");
                    Expense.SetRange(Posted, false);
                    Expense.SetRange("Expense Account Type", Expense."Expense Account Type"::Item);
                    if Expense.FindFirst then
                        Error(ItemPostingInExpNotAllowedErr, FieldCaption("Expense Posting"), "Expense Posting", TableCaption,
                          Expense.TableCaption);
                end;

                if "Expense Posting" = "Expense Posting"::"Preferable Purchase Invoice" then begin
                    if "Post Bank Trans. on Import" then begin
                        if not Confirm(EnablePurchaseInvoiceQst) then
                            Error('');
                        Validate("Post Bank Trans. on Import", false);
                    end;

                    TestField("Post Bank Trans. on Import", false);
                    TestField("Settlement App. Area", "Settlement App. Area"::Disabled);
                    ExpensePostingSetup.SetFilter("External Posting Account Type", '=%1|%2',
                      ExpensePostingSetup."External Posting Account Type"::"Lessor Pay Type",
                      ExpensePostingSetup."External Posting Account Type"::"Dataloen Pay Type");
                    if ExpensePostingSetup.FindFirst then
                        Error(PurchasePostingNotAllowedErr, Rec.TableCaption, FieldCaption("Expense Posting"), Format(xRec."Expense Posting"),
                          Format(ExpensePostingSetup."External Posting Account Type"));
                    Expense.SetRange(Posted, false);
                    Expense.SetFilter("External Posting Account Type", '=%1|%2',
                      Expense."External Posting Account Type"::"Lessor Pay Type",
                      Expense."External Posting Account Type"::"Dataloen Pay Type");
                    if Expense.FindFirst then
                        Error(PurchasePostingNotAllowedErr, Rec.TableCaption, FieldCaption("Expense Posting"), Format(xRec."Expense Posting"),
                          Format(Expense."External Posting Account Type"));
                end;
            end;
        }
        field(120; "Invoice Nos."; Code[20])
        {
            Caption = 'Invoice No. Series';
            TableRelation = "No. Series";
        }
        field(122; "Approval Template"; BLOB)
        {
            Caption = 'Approval Template';
            SubType = UserDefined;
        }
        field(123; "Approval E-Mail Subject"; Text[80])
        {
            Caption = 'Approval E-Mail Subject';
        }
        field(124; "Last Status E-Mail Sent"; Date)
        {
            CalcFormula = Max("CDC Event Register"."Creation Date" WHERE(Area = CONST("Purch. Approval Status E-mail")));
            Caption = 'Last Status E-Mail Sent';
            Editable = false;
            FieldClass = FlowField;
        }
        field(125; "Reminder Template"; BLOB)
        {
            Caption = 'Reminder Template';
        }
        field(126; "Reminder E-Mail Subject"; Text[80])
        {
            Caption = 'Reminder E-Mail Subject';
        }
        field(140; "Sender E-mail"; Text[80])
        {
            Caption = 'Sender E-mail';
        }
        field(141; "Sender Name"; Text[50])
        {
            Caption = 'Sender Name';
        }
        field(142; "SMTP Require SSL/TLS"; Boolean)
        {
            Caption = 'SMTP Require SSL/TLS';

            trigger OnValidate()
            var
                SmtpMailSetup: Record "SMTP Mail Setup";
            begin
                if SmtpMailSetup.Get then
                    if ("SMTP Require SSL/TLS" <> SmtpMailSetup."Secure Connection") then
                        Error(MailSetupErr, SmtpMailSetup.TableCaption);
            end;
        }
        field(143; "Force Field Update in CO"; Boolean)
        {
            Caption = 'Force Field Update in Continia Online';
            Editable = false;
        }
        field(150; "Error E-Mail"; Text[80])
        {
            Caption = 'Error E-Mail';
        }
        field(153; "Dynamics NAV Server Tenant"; Text[50])
        {
            Caption = 'Dynamics NAV Server Tenant';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                if Company.FindSet then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get then begin
                                EMSetup."Dynamics NAV Server Tenant" := "Dynamics NAV Server Tenant";
                                EMSetup.Modify;
                            end;
                        end;
                    until Company.Next = 0;

                Modify;
            end;
        }
        field(154; "Dynamics NAV Server Name"; Text[50])
        {
            Caption = 'Dynamics NAV Server Name';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                Company.FindFirst;
                repeat
                    if Company.Name <> CompanyName then begin
                        EMSetup.ChangeCompany(Company.Name);
                        if EMSetup.Get then begin
                            EMSetup."Dynamics NAV Server Name" := "Dynamics NAV Server Name";
                            EMSetup.Modify;
                        end;
                    end;
                until Company.Next = 0;

                Modify;
            end;
        }
        field(155; "Dynamics NAV Server Instance"; Text[50])
        {
            Caption = 'Dynamics NAV Server Instance';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                Company.FindFirst;
                repeat
                    if Company.Name <> CompanyName then begin
                        EMSetup.ChangeCompany(Company.Name);
                        if EMSetup.Get then begin
                            EMSetup."Dynamics NAV Server Instance" := "Dynamics NAV Server Instance";
                            EMSetup.Modify;
                        end;
                    end;
                until Company.Next = 0;

                Modify;
            end;
        }
        field(156; "Dynamics NAV Server Port"; Integer)
        {
            Caption = 'Dynamics NAV Server Port';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                Company.FindFirst;
                repeat
                    if Company.Name <> CompanyName then begin
                        EMSetup.ChangeCompany(Company.Name);
                        if EMSetup.Get then begin
                            EMSetup."Dynamics NAV Server Port" := "Dynamics NAV Server Port";
                            EMSetup.Modify;
                        end;
                    end;
                until Company.Next = 0;

                Modify;
            end;
        }
        field(157; "Dynamics NAV Web Server Name"; Text[50])
        {
            Caption = 'Dynamics NAV Web Server Name';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                if Company.FindSet then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get then begin
                                EMSetup."Dynamics NAV Web Server Name" := "Dynamics NAV Web Server Name";
                                EMSetup.Modify;
                            end;
                        end;
                    until Company.Next = 0;

                Modify;
            end;
        }
        field(158; "Dynamics NAV Web Server Port"; Integer)
        {
            Caption = 'Dynamics NAV Web Server Port';
            MinValue = 0;

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                if Company.FindSet then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get then begin
                                EMSetup."Dynamics NAV Web Server Port" := "Dynamics NAV Web Server Port";
                                EMSetup.Modify;
                            end;
                        end;
                    until Company.Next = 0;

                Modify;
            end;
        }
        field(159; "Dynamics NAV Web Server Inst."; Text[50])
        {
            Caption = 'Dynamics NAV Web Server Instance';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                if Company.FindSet then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get then begin
                                EMSetup."Dynamics NAV Web Server Inst." := "Dynamics NAV Web Server Inst.";
                                EMSetup.Modify;
                            end;
                        end;
                    until Company.Next = 0;

                Modify;
            end;
        }
        field(160; "Dynamics NAV Web Server Tenant"; Text[50])
        {
            Caption = 'Dynamics NAV Web Server Tenant';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                if Company.FindSet then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get then begin
                                EMSetup."Dynamics NAV Web Server Tenant" := "Dynamics NAV Web Server Tenant";
                                EMSetup.Modify;
                            end;
                        end;
                    until Company.Next = 0;

                Modify;
            end;
        }
        field(161; "Dynamics NAV Web Server SSL"; Boolean)
        {
            Caption = 'Use Dynamics NAV Web Server With SSL';
        }
        field(201; "Expense Template Name"; Code[10])
        {
            Caption = 'Expense Template Name';
            TableRelation = "Gen. Journal Template" WHERE(Type = CONST(General));
        }
        field(251; "Expense Batch Name"; Code[10])
        {
            Caption = 'Expense Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Expense Template Name"));
        }
        field(254; "Settlement Nos."; Code[20])
        {
            Caption = 'Settlement No. Series';
            TableRelation = "No. Series";
        }
        field(255; "Settlement Posted Nos."; Code[20])
        {
            Caption = 'Settlement Posting No. Series';
            TableRelation = "No. Series";
        }
        field(256; "Expense Posted Nos."; Code[20])
        {
            Caption = 'Expense Posting No. Series';
            TableRelation = "No. Series";
        }
        field(258; "Mileage Posted Nos."; Code[20])
        {
            Caption = 'Mileage Posting No. Series';
            TableRelation = "No. Series";
        }
        field(300; "Shortcut Field 1 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 1 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(301; "Shortcut Field 2 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 2 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(302; "Shortcut Field 3 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 3 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(303; "Shortcut Field 4 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 4 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(304; "Shortcut Field 5 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 5 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(305; "Shortcut Field 6 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 6 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(306; "Shortcut Field 7 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 7 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(307; "Shortcut Field 8 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 8 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(308; "Shortcut Field 9 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 9 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(309; "Shortcut Field 10 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 10 Code (Exp.)", DATABASE::"CEM Expense");
            end;
        }
        field(310; "Data Version"; Integer)
        {
            Caption = 'Data Version';
        }
        field(320; "Shortcut Field 1 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 1 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(321; "Shortcut Field 2 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 2 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(322; "Shortcut Field 3 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 3 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(323; "Shortcut Field 4 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 4 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(324; "Shortcut Field 5 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 5 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(325; "Shortcut Field 6 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 6 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(326; "Shortcut Field 7 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 7 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(327; "Shortcut Field 8 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 8 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(328; "Shortcut Field 9 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 9 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(329; "Shortcut Field 10 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 10 Code (App.)", DATABASE::"Approval Entry");
            end;
        }
        field(340; "Distance Unit"; Option)
        {
            Caption = 'Distance Unit';
            OptionCaption = 'Km,Miles';
            OptionMembers = Km,Miles;

            trigger OnValidate()
            var
                Mileage: Record "CEM Mileage";
                MileageDetail: Record "CEM Mileage Detail";
                MileageInbox: Record "CEM Mileage Inbox";
                DistanceFactor: Decimal;
            begin
                //1 mile = 1.609344 kilometers
                if "Distance Unit" = xRec."Distance Unit" then
                    exit;
                if Mileage.FindFirst then begin
                    if not Confirm(ConfirmTxtConvertQst, false) then
                        Error('');
                    if "Distance Unit" = "Distance Unit"::Km then
                        DistanceFactor := MileageInbox.MilesPrKm
                    else
                        DistanceFactor := 1 / MileageInbox.MilesPrKm;

                    Mileage.SetRange(Posted, true);
                    if Mileage.FindFirst then
                        Error(UnitChangeNotAllowedErr, FieldCaption("Distance Unit"));

                    Mileage.SetRange(Posted);
                    if Mileage.FindFirst then
                        repeat
                            Mileage."Total Distance" := Round(Mileage."Total Distance" * DistanceFactor, 0.00001);
                            Mileage."Calculated Distance" := Round(Mileage."Calculated Distance" * DistanceFactor, 0.00001);
                            Mileage.Modify;
                        until Mileage.Next = 0;

                    if MileageDetail.FindFirst then
                        repeat
                            MileageDetail."From Distance" := Round(MileageDetail."From Distance" * DistanceFactor, 0.00001);
                            MileageDetail."To Distance" := Round(MileageDetail."To Distance" * DistanceFactor, 0.00001);
                            MileageDetail.Distance := Round(MileageDetail.Distance * DistanceFactor, 0.00001);
                            MileageDetail.Modify;
                        until MileageDetail.Next = 0;

                    MileageInbox.SetFilter(Status, '<%1', MileageInbox.Status::Accepted);
                    if MileageInbox.FindFirst then
                        repeat
                            MileageInbox."Total Distance" := Round(MileageInbox."Total Distance" * DistanceFactor, 0.00001);
                            MileageInbox."Calculated Distance" := Round(MileageInbox."Calculated Distance" * DistanceFactor, 0.00001);
                            MileageInbox.Modify;
                        until MileageInbox.Next = 0;
                end;
            end;
        }
        field(350; "Mileage Posting Description"; Text[30])
        {
            Caption = 'Mileage Posting Description';
        }
        field(359; "Deduct home-office distance"; Boolean)
        {
            Caption = 'Deduct distance between home and office';

            trigger OnValidate()
            begin
                ConfigureToFromHomeFields;
            end;
        }
        field(360; "Enable 60 day rule"; Boolean)
        {
            Caption = 'Enable 60 day rule check';

            trigger OnValidate()
            var
                ConfigFields: Record "CEM Configured Field Type";
            begin
                ConfigureToFromHomeFields;
            end;
        }
        field(361; "Distance Variance % Allowed"; Decimal)
        {
            Caption = 'Distance Difference Allowed (%)';
            DecimalPlaces = 0 : 2;
        }
        field(363; "Matching - date var. allowed"; Integer)
        {
            Caption = 'Date variance allowed when matching (Days)';
        }
        field(364; "Submit Cash Expenses in LCY"; Boolean)
        {
            Caption = 'Submit Cash Expenses in LCY';

            trigger OnValidate()
            begin
                if "Submit Cash Expenses in LCY" and "Post in Expense Currency" then
                    if not Confirm(StrSubstNo(WillChangeOneValue, FieldCaption("Post in Expense Currency"))) then
                        Error('')
                    else
                        Validate("Post in Expense Currency", false);
            end;
        }
        field(366; "Post in Expense Currency"; Boolean)
        {
            Caption = 'Post in Expense Currency';
        }
        field(367; "Auto Submit Exp. for Approval"; Boolean)
        {
            Caption = 'Auto Submit Expenses for Approval';
        }
        field(369; "Auto Submit Mil. for Approval"; Boolean)
        {
            Caption = 'Auto Submit Mileage for Approval';
        }
        field(370; "Enable Mileage"; Boolean)
        {
            Caption = 'Enable Mileage';

            trigger OnValidate()
            var
                MileageRates: Record "CEM Mileage Rate";
            begin
                if (xRec."Enable Mileage" <> "Enable Mileage") and "Enable Mileage" then
                    if MileageRates.IsEmpty then
                        Message(RememberMileageRatesMsg);
            end;
        }
        field(371; "Shortcut Field 1 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 1 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(372; "Shortcut Field 2 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 2 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(373; "Shortcut Field 3 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 3 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(374; "Shortcut Field 4 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 4 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(375; "Shortcut Field 5 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 5 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(376; "Shortcut Field 6 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 6 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(377; "Shortcut Field 7 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 7 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(378; "Shortcut Field 8 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 8 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(379; "Shortcut Field 9 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 9 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(380; "Shortcut Field 10 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 10 Code (Mil.)", DATABASE::"CEM Mileage");
            end;
        }
        field(381; "Auto Submit Sttl. for Approval"; Boolean)
        {
            Caption = 'Auto Submit Settlement for Approval';
        }
        field(387; "Settlement App. Area"; Option)
        {
            Caption = 'Settlement';
            OptionCaption = 'Disabled,Optional,Mandatory';
            OptionMembers = Disabled,Optional,Mandatory;

            trigger OnValidate()
            begin
                if (xRec."Settlement App. Area" = "Settlement App. Area") then
                    exit;
                if (xRec."Settlement App. Area" = xRec."Settlement App. Area"::Disabled) and SettlementEnabled then begin
                    if "Expense Posting" = "Expense Posting"::"Use General Journal" then begin
                        if not "Post Bank Trans. on Import" then begin
                            if Confirm(EnableSettlementQst) then
                                Validate("Post Bank Trans. on Import", true)
                            else
                                Error('');
                        end;
                    end else begin
                        Message(EnableSettlementDisablesPIMsg + '\\' + EnableSettlementReqChangePIMsg);
                        Error('');
                    end;
                end;

                "Enable Settlement" := SettlementEnabled;
            end;
        }
        field(390; "Enable Settlement"; Boolean)
        {
            Caption = 'Enable Settlement';
        }
        field(391; "Enable Per Diem"; Boolean)
        {
            Caption = 'Enable Per Diem';

            trigger OnValidate()
            var
                PerDiemGroup: Record "CEM Per Diem Group";
                PerDiemRate: Record "CEM Per Diem Rate";
            begin
                if (xRec."Enable Per Diem" <> "Enable Per Diem") and "Enable Per Diem" then
                    if PerDiemRate.IsEmpty then
                        Message(RememberPerDiemRatesMsg, PerDiemGroup.TableCaption);
            end;
        }
        field(392; "Auto Submit Per Diem for App."; Boolean)
        {
            Caption = 'Auto Submit Per Diem for Approval';
        }
        field(393; "Per Diem Posted Nos."; Code[20])
        {
            Caption = 'Per Diem Posting No. Series';
            TableRelation = "No. Series";
        }
        field(394; "Per Diem Source Code"; Code[10])
        {
            Caption = 'Per Diem Source Code';
            TableRelation = "Source Code";
        }
        field(395; "Post Bank Trans. on Import"; Boolean)
        {
            Caption = 'Post Bank Transactions on Import';

            trigger OnValidate()
            var
                BankTransPost: Codeunit "CEM Bank Transaction-Post";
            begin
                if "Post Bank Trans. on Import" = xRec."Post Bank Trans. on Import" then
                    exit;

                if "Post Bank Trans. on Import" then begin
                    if "Intermediate Expense Account" = '' then begin
                        Message(EnablingPostOnImportMsg);
                        Error('');
                    end;
                    if ("Expense Posting" = "Expense Posting"::"Preferable Purchase Invoice") then begin
                        Message(EnablePostOnImpNotPossibleMsg);
                        Error('');
                    end;
                    TestField("Expense Posting", "Expense Posting"::"Use General Journal");
                    BankTransPost.PostAllBankTransactions(true);
                end else begin
                    if SettlementEnabled then begin
                        Message(DisablePostOnImpNotPossibleMsg);
                        Error('');
                    end;
                    TestField("Settlement App. Area", "Settlement App. Area"::Disabled);
                    BankTransPost.ReversePostAllBankTransactions(true);
                end;
            end;
        }
        field(396; "Per Diem Posting Description"; Text[30])
        {
            Caption = 'Per Diem Posting Description';
        }
        field(397; "Calc. mil. across companies"; Boolean)
        {
            Caption = 'Calculate mileage across companies';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Mileage: Record "CEM Mileage";
                MileageRate: Record "CEM Mileage Rate";
                Company: Record Company;
            begin
                Mileage.SetRange(Posted, true);
                if not Mileage.IsEmpty then begin
                    Company.SetFilter(Name, '<>%1', CompanyName);
                    if Company.FindSet then
                        repeat
                            Mileage.ChangeCompany(Company.Name);
                            if Mileage.Count > 0 then
                                Error(PostedMilExistErr, FieldCaption("Calc. mil. across companies"), Company.Name);
                        until Company.Next = 0;
                end;

                Company.Reset;
                if Company.Count > 1 then
                    if not Confirm(UpdateInAllCompaniesQst, false, FieldCaption("Calc. mil. across companies")) then
                        Error('');

                //UPDATE IN ALL THE OTHER COMPANIES
                Company.SetFilter(Name, '<>%1', CompanyName);
                if Company.FindSet then
                    repeat
                        EMSetup.ChangeCompany(Company.Name);
                        if EMSetup.Get then begin
                            EMSetup."Calc. mil. across companies" := "Calc. mil. across companies";
                            EMSetup.Modify;
                        end;
                    until Company.Next = 0;

                //RECALCULATE IN ALL THE COMPANIES
                Company.Reset;
                if Company.FindSet then
                    repeat
                        Mileage.Reset;
                        Mileage.ChangeCompany(Company.Name);
                        if not Mileage.IsEmpty then begin
                            MileageRate.ChangeCompany(Company.Name);
                            if MileageRate.FindSet then
                                repeat
                                    MileageRate.SetGlobalVars(Company.Name, "Calc. mil. across companies");
                                    MileageRate.RecalculateMileageRate;
                                until MileageRate.Next = 0;
                        end;
                    until Company.Next = 0;
            end;
        }
        field(400; "Re-Get Transactions"; Boolean)
        {
            Caption = 'Re-Get Transactions';
        }
        field(401; "Shortcut Field 1 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 1 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(402; "Shortcut Field 2 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 2 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(403; "Shortcut Field 3 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 3 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(404; "Shortcut Field 4 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 4 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(405; "Shortcut Field 5 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 5 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(406; "Shortcut Field 6 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 6 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(407; "Shortcut Field 7 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 7 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(408; "Shortcut Field 8 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 8 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(409; "Shortcut Field 9 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 9 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(410; "Shortcut Field 10 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Shortcut Field 10 Code (Sttl.)", DATABASE::"CEM Expense Header");
            end;
        }
        field(411; "Include for Status Report"; Option)
        {
            Caption = 'Posted';
            OptionCaption = 'All,Posted,Not Posted';
            OptionMembers = All,Posted,"Not Posted";
        }
        field(412; "Include for Status Report Paid"; Option)
        {
            Caption = 'Reimbursed';
            OptionCaption = 'All,Reimbursed,Not reimbursed';
            OptionMembers = All,Paid,"Not Paid";
        }
        field(413; "Report Starting Date Formula"; DateFormula)
        {
            Caption = 'Report Starting Date Formula';
        }
        field(414; "Report Ending Date Formula"; DateFormula)
        {
            Caption = 'Report Ending Date Formula';
        }
        field(415; "Last Statement No."; Code[20])
        {
            Caption = 'Last Statement No.';
            Editable = false;
        }
        field(416; "Matching Method"; Option)
        {
            Caption = 'Matching Method';
            Description = 'To be deleted';
            OptionCaption = 'Always Required,Never Required,Required from Date';
            OptionMembers = "Always Required","Never Required","Required from Date";
        }
        field(417; "Matching Required Date"; Date)
        {
            Caption = 'Matching Required Date';
        }
        field(419; "Keep history in CO"; Option)
        {
            Caption = 'Keep History in Continia Online';
            OptionCaption = 'Never,6 Months,12 Months';
            OptionMembers = Never,"6 Months","12 Months";

            trigger OnValidate()
            begin
                if "Keep history in CO" = "Keep history in CO"::Never then
                    if not Confirm(COHistoryDisabledQst) then
                        Error('');
            end;
        }
        field(420; "Short. Fld. 1 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 1 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(421; "Short. Fld. 2 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 2 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(422; "Short. Fld. 3 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 3 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(423; "Short. Fld. 4 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 4 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(424; "Short. Fld. 5 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 5 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(425; "Short. Fld. 6 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 6 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(426; "Short. Fld. 7 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 7 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(427; "Short. Fld. 8 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 8 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(428; "Short. Fld. 9 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 9 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(429; "Short. Fld. 10 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
            TableRelation = "CEM Field Type" WHERE("System Field" = CONST(false));

            trigger OnValidate()
            begin
                CheckShortcutField("Short. Fld. 10 Code (Per Diem)", DATABASE::"CEM Per Diem");
            end;
        }
        field(430; "Use Entertainment Allowance"; Boolean)
        {
            Caption = 'Enable allowance for entertainment';

            trigger OnValidate()
            begin
                if not Rec."Use Entertainment Allowance" then
                    PerDiemPostingGroup.DisableEntertainmentAllowance;
            end;
        }
        field(431; "Use Drinks Allowance"; Boolean)
        {
            Caption = 'Enable allowance for drinks';

            trigger OnValidate()
            begin
                if not Rec."Use Drinks Allowance" then
                    PerDiemPostingGroup.DisableDrinksAllowance;
            end;
        }
        field(432; "Use Transport Allowance"; Boolean)
        {
            Caption = 'Enable allowance for transportation';

            trigger OnValidate()
            begin
                if not Rec."Use Transport Allowance" then
                    PerDiemPostingGroup.DisableTransportAllowance;
            end;
        }
        field(433; "Use Settl. Departure/Return DT"; Boolean)
        {
            Caption = 'Use Settlement Departure and Return Date/Time';
        }
        field(434; "Matching Method 2"; Option)
        {
            Caption = 'Matching Method';
            OptionCaption = 'Never Required,Always Required,Required from Date';
            OptionMembers = "Never Required","Always Required","Required from Date";

            trigger OnValidate()
            begin
                if "Matching Method 2" in ["Matching Method 2"::"Never Required", "Matching Method 2"::"Always Required"] then
                    "Matching Required Date" := 0D;
            end;
        }
        field(435; "Enable Per Diem Destinations"; Boolean)
        {
            Caption = 'Enable multiple destinations';

            trigger OnValidate()
            begin
                if Rec."Enable Per Diem Destinations" then
                    Rec.CreateAndConfigureMultipleDest
                else
                    Rec.DisableMultipleDestFields;
            end;
        }
        field(436; "Allowances given by default"; Boolean)
        {
            Caption = 'Allowances given by default';
        }
        field(500; "Picture Size"; Integer)
        {
            Caption = 'Picture Size (Pixels)';
            Description = 'To be deleted';
            MinValue = 500;
        }
        field(501; "Picture Quality (%)"; Integer)
        {
            Caption = 'Picture Quality (%)';
            Description = 'To be deleted';
            MaxValue = 100;
            MinValue = 0;
        }
        field(502; "Picture Quality Web Client (%)"; Integer)
        {
            Caption = 'Picture Quality Web Client (%)';
            Description = 'To be deleted';
            MaxValue = 100;
            MinValue = 0;
        }
        field(503; "Exp. Description From Bank"; Boolean)
        {
            Caption = 'Set Expense Description from Bank';
        }
        field(600; "Bank Transaction Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(601; "Expense Source Code"; Code[10])
        {
            Caption = 'Expense Source Code';
            TableRelation = "Source Code";
        }
        field(602; "Mileage Source Code"; Code[10])
        {
            Caption = 'Mileage Source Code';
            TableRelation = "Source Code";
        }
        field(603; "Settlement Source Code"; Code[10])
        {
            Caption = 'Settlement Source Code';
            TableRelation = "Source Code";
        }
        field(604; "Bank Trs. Reverse Source Code"; Code[10])
        {
            Caption = 'Reverse Source Code';
            TableRelation = "Source Code";
        }
        field(700; "Lessor Journal Name"; Code[10])
        {
            Caption = 'Lessor Journal Name';

            trigger OnValidate()
            var
                LessorIntegration: Codeunit "CEM Lessor Integration";
            begin
                LessorIntegration.ValidateLessorJournalName("Lessor Journal Name");
            end;
        }
        field(750; "Dataloen Token"; Text[80])
        {
            Caption = 'Dataloen Token';
        }
        field(752; "Ignore BT Duplicate Check"; Boolean)
        {
            Caption = 'Disable duplicate check';
        }
        field(754; "Allow duplicate Card ID"; Boolean)
        {
            Caption = 'Allow duplicated Card ID';
            Description = 'To be deleted';
        }
        field(755; "Use CC Mapping for dup. Cards"; Boolean)
        {
            Caption = 'Enable multiple users per credit card';
        }
        field(760; "Allow Mileage Attachment"; Boolean)
        {
            Caption = 'Enable Mileage Attachment';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        AboutEM: Codeunit "CEM About Expense Management";
    begin
        "Data Version" := AboutEM.GetCurrentVersion;
    end;

    var
        PerDiemPostingGroup: Record "CEM Per Diem Posting Group";
        BeAwareExistingCardsTxt: Label 'Please be aware that there are one or more %1 with %2 = %3 and %4 = %5\\These must be updated manually.';
        COHistoryDisabledQst: Label 'This will disable and delete the history in Continia Online.\\Do you wish to proceed?';
        CompanyLogoUploaded: Label 'The company logo has been uploaded.';
        ConfirmReplaceCompanyLogo: Label 'The company logo has already been uploaded. Do you wish to replace it?';
        ConfirmTxtConvertQst: Label 'Convert mileage to new unit?';
        CreditCardVendorNotallowedErr: Label 'Creditcard %1 for user %2 has type %3 which is not allowed unless %4 is %5.';
        DisablePostOnImpNotPossibleMsg: Label 'When Settlement is enabled, it is not possible to disable Post Bank Transaction on Import.';
        DisablingPostOnImportMsg: Label 'When disabling Post Bank Transaction on Import, an Intermediate Expense Account is needed.';
        EnablePostOnImpNotPossibleMsg: Label 'When Expense Posting is "Preferable Purchase Invoice", then it is not possible to enable Post Bank Transaction on Import.';
        EnablePurchaseInvoiceQst: Label 'When enabling "Preferable Purchase Invoice", you are disabling "Post Bank Transactions on Import.".\\Do you want to continue?';
        EnableSettlementDisablesPIMsg: Label 'When enabling Settlement you are disabling Purchase Document Posting.';
        EnableSettlementQst: Label 'When enabling Settlement, Post Bank Transaction on Import will be enabled.\\Do you want to continue?';
        EnableSettlementReqChangePIMsg: Label 'This requires that you first change Expense Posting from "Preferable Purchase Invoice" to "Use General Journal".';
        EnablingPostOnImportMsg: Label 'When enabling Post Bank Transaction on Import, an Intermediate Expense Account is needed.';
        ErrCompanyLogoFormat: Label 'File format must be PNG.';
        ErrCompanyLogoSize: Label 'Image dimensions must be 60 x 60 pixels.';
        InvalidFilePathsErr: Label 'The companies %1 and %2 have been setup with conflicting file paths, the file paths must be unique in each company.\Change the file paths in the Expense Management setup or enable %3, before you can continue.';
        ItemPostingInExpNotAllowedErr: Label 'Item posting is not allowed when %1 is %2 in the %3. Please correct the posting setup for %4 first.';
        ItemPostingInPSNotAllowedErr: Label 'Item posting in is not allowed when selecting %1. Please change the Posting Setup.';
        LocationNotFoundErr: Label 'File location does not exist.\Please check permissions and invalid characters.\%1';
        MailSetupErr: Label 'This setup must be the same as in %1. Please change that one first.';
        MovingFilesTxt: Label 'Moving files\#1######################\@2@@@@@@@@@@@@@@@@@@@@@@';
        NotAllowedWhenSaasErr: Label 'The action is not allowed when using software as a service.';
        OnPremAppNotInstalled: Label 'You must install the Continia Expense Management 365 on-premises app, to utilize server-side resources such as file system and assemblies.';
        PostedMilExistErr: Label '%1 cannot be changed because posted mileage exist in %2.';
        PreapprovalAmountCaption: Label 'Pre-approval Amount';
        PurchasePostingNotAllowedErr: Label '%2 can only be %3 in %1, when expenses with %4 exist.';
        RememberMileageRatesMsg: Label 'Please remember to add the mileage rates.';
        RememberPerDiemRatesMsg: Label 'Please remember to add the Per Diem rates in the %1';
        SettlementsAreDisabled: Label 'Settlements are disabled. Please enable Settlements by chosing Optional or Mandatory in the Expense Management Setup.';
        SixtyDayRuleFieldsErr: Label 'The fields FromHome and ToHome must be configured for Mileage before you can enable the 60 day rule check.';
        SourceTableCannotBeDimsErr: Label 'The Custom Field %1 is also a Global Dimension and it''s already visible on the %2.';
        SyncRequiredMsg: Label 'Continia Online history will be changed from %1 to %2 after the next synchronization.';
        TestMailTitleLbl: Label 'Continia Expense Management - SMTP Test Email Message';
        TextMoveFileSystemSetupQst: Label 'One or more documents have already been imported. When you change %1 the system will automatically move all files to %2. This can take a long time depending on the number of documents in the system.\\Do you want to continue?';
        TextMoveFromXToY: Label 'One or more documents have already been imported.\\When you change %1 the system will automatically move all files from the %2 to the %3. This can take a long time depending on the number of documents in the system.\\Do you want to continue?';
        UnitChangeNotAllowedErr: Label 'Changing %1 is not Allowed when some Mileage have been posted.';
        UpdateInAllCompaniesQst: Label '%1 will be updated in all the companies. Do you want to continue?';
        WillChangeOneValue: Label 'This will disable %1. Do you want to continue?';


    procedure LookupLessorJournalName(var Text: Text[1024]): Boolean
    var
        LessorIntegration: Codeunit "CEM Lessor Integration";
    begin
        exit(LessorIntegration.LookupLessorJournalName(Text));
    end;

    local procedure MoveDocFilesToNewStorageSetup(CaptionFieldChanged: Text[100])
    var
        ContCompSetup: Record "CDC Continia Company Setup";
        EMAttachment: Record "CEM Attachment";
        EMAttachmentInbox: Record "CEM Attachment Inbox";
    begin
        if not (EMAttachment.FindSet or EMAttachmentInbox.FindSet) then
            exit;

        ContCompSetup.Get;

        case true of
            ("Document Storage Type" = "Document Storage Type"::"File System") and
          (xRec."Document Storage Type" = xRec."Document Storage Type"::"File System"):
                if not Confirm(TextMoveFileSystemSetupQst, false, CaptionFieldChanged, GetStorageLocation(Rec, ContCompSetup)) then
                    Error('');

            ("Document Storage Type" <> xRec."Document Storage Type"):
                if not Confirm(TextMoveFromXToY, false, CaptionFieldChanged, xRec."Document Storage Type", "Document Storage Type") then
                    Error('');
        end;

        if (("Document Storage Type" = "Document Storage Type"::"File System") and
            (xRec."Document Storage Type" = xRec."Document Storage Type"::Database)) or
           (("Document Storage Type" = "Document Storage Type"::"Azure Blob Storage") and
            (xRec."Document Storage Type" <> xRec."Document Storage Type"::"Azure Blob Storage"))
        then
            // To prevent page run when updated from setup wizard
            if GuiAllowed and (CurrFieldNo = FieldNo("Document Storage Type")) then
                UpdateStorageSettings;

        MoveAttachments(Rec, xRec, ContCompSetup, ContCompSetup);
    end;


    procedure MoveDocFilesToNewStorageSetup2(EMSetup: Record "CEM Expense Management Setup"; xEMSetup: Record "CEM Expense Management Setup")
    var
        ContCompSetup: Record "CDC Continia Company Setup";
    begin
        ContCompSetup.Get;
        MoveAttachments(Rec, xRec, ContCompSetup, ContCompSetup);
    end;

    local procedure MoveAttachments(EMSetup: Record "CEM Expense Management Setup"; xEMSetup: Record "CEM Expense Management Setup"; ContCompSetup: Record "CDC Continia Company Setup"; xContCompSetup: Record "CDC Continia Company Setup")
    var
        EMAttachment: Record "CEM Attachment";
        EMAttachmentInbox: Record "CEM Attachment Inbox";
        Window: Dialog;
        Counter: Integer;
        Total: Integer;
    begin
        if GuiAllowed then
            Window.Open(MovingFilesTxt);

        Total := EMAttachment.Count + EMAttachmentInbox.Count;
        if EMAttachment.FindSet then
            repeat
                Counter += 1;
                if GuiAllowed then begin
                    Window.Update(1, EMAttachment."Doc. Ref. No.");
                    Window.Update(2, Counter / Total * 10000 div 1);
                end;

                CopyAttachToNewStorageSetup(EMAttachment, EMSetup, xEMSetup, ContCompSetup, xContCompSetup);
            until EMAttachment.Next = 0;

        if EMAttachmentInbox.FindSet then
            repeat
                Counter += 1;
                if GuiAllowed then begin
                    Window.Update(1, EMAttachment."Doc. Ref. No.");
                    Window.Update(2, Counter / Total * 10000 div 1);
                end;

                CopyAttachInbToNewStorageSetup(EMAttachmentInbox, EMSetup, xEMSetup, ContCompSetup, xContCompSetup);
            until EMAttachmentInbox.Next = 0;

        Counter := 0;
        Window.Open(MovingFilesTxt);

        EMAttachment.SetSetup(xEMSetup, xContCompSetup);
        if EMAttachment.FindSet then
            repeat
                Counter += 1;
                if GuiAllowed then begin
                    Window.Update(1, EMAttachment."Doc. Ref. No.");
                    Window.Update(2, Counter / Total * 10000 div 1);
                end;

                ClearAttachmentFiles(EMAttachment);
            until EMAttachment.Next = 0;

        EMAttachmentInbox.SetSetup(xEMSetup, xContCompSetup);
        if EMAttachmentInbox.FindSet then
            repeat
                Counter += 1;
                if GuiAllowed then begin
                    Window.Update(1, EMAttachment."Doc. Ref. No.");
                    Window.Update(2, Counter / Total * 10000 div 1);
                end;

                ClearAttachmentInboxFiles(EMAttachmentInbox);
            until EMAttachmentInbox.Next = 0;

        Window.Close;
    end;

    local procedure CopyAttachToNewStorageSetup(EMAttachment: Record "CEM Attachment"; EMSetup: Record "CEM Expense Management Setup"; xEMSetup: Record "CEM Expense Management Setup"; ContCompSetup: Record "CDC Continia Company Setup"; xContCompSetup: Record "CDC Continia Company Setup")
    var
        TempFile: Record "CDC Temp File" temporary;
        NewAttachment: Record "CEM Attachment";
    begin
        EMAttachment.SetSetup(xEMSetup, xContCompSetup);
        NewAttachment := EMAttachment;
        NewAttachment.SetSetup(EMSetup, ContCompSetup);

        if EMAttachment.HasAttachment then begin
            EMAttachment.GetAttachment(TempFile);
            NewAttachment.SetAttachment(TempFile, true);
        end;

        if EMAttachment.HasPDF then begin
            EMAttachment.GetPDF(TempFile);
            NewAttachment.SetPDF(TempFile, true);
        end;
    end;

    local procedure CopyAttachInbToNewStorageSetup(EMAttachmentInbox: Record "CEM Attachment Inbox"; EMSetup: Record "CEM Expense Management Setup"; xEMSetup: Record "CEM Expense Management Setup"; ContCompSetup: Record "CDC Continia Company Setup"; xContCompSetup: Record "CDC Continia Company Setup")
    var
        TempFile: Record "CDC Temp File" temporary;
        NewAttachmentInbox: Record "CEM Attachment Inbox";
    begin
        EMAttachmentInbox.SetSetup(xEMSetup, xContCompSetup);
        NewAttachmentInbox := EMAttachmentInbox;
        NewAttachmentInbox.SetSetup(EMSetup, ContCompSetup);

        if EMAttachmentInbox.HasAttachment then begin
            EMAttachmentInbox.GetAttachmentServerFile(TempFile);
            NewAttachmentInbox.SetAttachment(TempFile);
        end;

        if EMAttachmentInbox.HasPDF then begin
            EMAttachmentInbox.GetPDFServerFile(TempFile);
            NewAttachmentInbox.SetPDF(TempFile);
        end;
    end;

    local procedure ClearAttachmentFiles(var EMAttachment: Record "CEM Attachment")
    begin
        EMAttachment.ClearAttachment;
        EMAttachment.ClearPDF;
        EMAttachment.ClearPages;
    end;

    local procedure ClearAttachmentInboxFiles(var EMAttachmentInbox: Record "CEM Attachment Inbox")
    begin
        EMAttachmentInbox.ClearAttachment;
        EMAttachmentInbox.ClearPDF;
        EMAttachmentInbox.ClearPages;
    end;

    local procedure GetStorageLocation(EMSetup: Record "CEM Expense Management Setup"; ContCompSetup: Record "CDC Continia Company Setup") Location: Text[1024]
    var
        EMDocFileInterface: Codeunit "CEM Document File Interface";
    begin
        EMDocFileInterface.SetSetup(EMSetup, ContCompSetup);
        exit(EMDocFileInterface.GetStorageLocation);
    end;


    procedure PromptAndSendTestMail()
    var
        SmtpMailMgt: Codeunit "CDC SmtpMail Management";
    begin
        SmtpMailMgt.PromptAndSendEmail(TestMailTitleLbl);
    end;


    procedure IsFilePathUniqueCrossComp(FilePath: Text[200])
    var
        EMSetup2: Record "CEM Expense Management Setup";
        Company: Record Company;
        COLicenseMgt: Codeunit "CDC Continia Online Licn. Mgt.";
        SingleInstanceStorage: Codeunit "CDC Single Instance Storage";
        ActivationState: Option NeverActivated,NeedReactivation,Activated,OfflineStarted;
    begin
        if SingleInstanceStorage.GetDisableDCSetupFilePathCheck then
            exit;

        if "Company Code in Archive" then
            exit;

        Company.SetFilter(Name, '<>%1', CompanyName);
        if Company.FindSet then
            repeat
                EMSetup2.ChangeCompany(Company.Name);
                if EMSetup2.Get then
                    if EMSetup2."Document Storage Type" <> EMSetup2."Document Storage Type"::Database then
                        if not EMSetup2."Company Code in Archive" then
                            if COLicenseMgt.IsActiveInCompany('CDC', Company.Name) then
                                if (FilePath = EMSetup2."Archive Path") then
                                    Error(InvalidFilePathsErr, CompanyName, Company.Name, FieldCaption("Company Code in Archive"));
            until Company.Next = 0;
    end;


    procedure VerifyFilePathsCrossComp()
    begin
        IsFilePathUniqueCrossComp("Archive Path");
    end;

    local procedure CheckShortcutField(var FieldTypeCode: Code[20]; TableID: Integer)
    var
        FieldType: Record "CEM Field Type";
        TableFilterFieldEM: Record "CEM Table Filter Field EM";
        GLSetup: Record "General Ledger Setup";
        TableRef: RecordRef;
    begin
        if not (TableID in [DATABASE::"CEM Expense", DATABASE::"CEM Mileage", DATABASE::"CEM Per Diem",
          DATABASE::"CEM Expense Header", DATABASE::"Approval Entry"])
        then
            exit;

        if not FieldType.Get(FieldTypeCode) then
            exit;

        if not (FieldType."Source Table No." = DATABASE::"Dimension Value") then
            exit;

        if not TableFilterFieldEM.Get(FieldType."Source Table Filter GUID", FieldType.FieldNo(Code)) then
            exit;

        GLSetup.Get;
        if not (TableFilterFieldEM."Value (Text)" in [GLSetup."Global Dimension 1 Code", GLSetup."Global Dimension 2 Code"]) then
            exit;

        TableRef.Open(TableID);
        Error(SourceTableCannotBeDimsErr, FieldTypeCode, TableRef.Caption);
    end;


    procedure IsMatchingRequiredOnDate(Date: Date): Boolean
    begin
        if Date = 0D then
            Date := Today;

        case "Matching Method 2" of
            "Matching Method 2"::"Always Required":
                exit(true);
            "Matching Method 2"::"Never Required":
                exit(false);
            "Matching Method 2"::"Required from Date":
                exit(("Matching Required Date" <> 0D) and (Date >= "Matching Required Date"));
        end;
    end;


    procedure GetCOHistoryInMonths(): Integer
    begin
        case "Keep history in CO" of
            "Keep history in CO"::Never:
                exit(0);
            "Keep history in CO"::"6 Months":
                exit(6);
            "Keep history in CO"::"12 Months":
                exit(12);
        end;
    end;


    procedure UpdateStorageSettings(): Boolean
    var
        UpdateStorageSettingsPage: Page "CEM Update Storage Settings";
        NewDiskFileDirStructure: Option "One Directory","Year\Month","Year\Month\Day";
        NewAzureBlobContainerName: Text[50];
        NewAzureStorageAccountName: Text[50];
        NewAzureStorageAccountKey: Text[100];
        NewArchiveFilePath: Text[200];
    begin
        case "Document Storage Type" of
            "Document Storage Type"::"File System":
                begin
                    UpdateStorageSettingsPage.SetFilePaths("Archive Path", "Archive Directory Structure");
                    UpdateStorageSettingsPage.LookupMode := true;
                    if UpdateStorageSettingsPage.RunModal in [ACTION::LookupOK, ACTION::OK] then begin
                        UpdateStorageSettingsPage.GetFilePaths(NewArchiveFilePath, NewDiskFileDirStructure);
                        AddFolderSlash(NewArchiveFilePath);

                        if (NewArchiveFilePath <> "Archive Path") or
                          (NewDiskFileDirStructure <> "Archive Directory Structure")
                        then begin
                            if NewArchiveFilePath <> "Archive Path" then
                                "Archive Path" := NewArchiveFilePath;
                            if NewDiskFileDirStructure <> "Archive Directory Structure" then
                                "Archive Directory Structure" := NewDiskFileDirStructure;
                            Modify;
                        end;
                    end else
                        Error('');
                end;
            "Document Storage Type"::"Azure Blob Storage":
                begin
                    UpdateStorageSettingsPage.
                      SetAzureBlobSettings("Azure Storage Account Name", "Azure Storage Account Key", "Azure Blob Container Name");
                    UpdateStorageSettingsPage.LookupMode := true;
                    if UpdateStorageSettingsPage.RunModal in [ACTION::LookupOK, ACTION::OK] then begin
                        UpdateStorageSettingsPage.GetAzureBlobSettings(
                          NewAzureStorageAccountName, NewAzureStorageAccountKey, NewAzureBlobContainerName);
                        if (NewAzureStorageAccountName <> "Azure Storage Account Name") or
                          (NewAzureStorageAccountKey <> "Azure Storage Account Key") or
                          (NewAzureBlobContainerName <> "Azure Blob Container Name")
                        then begin
                            "Azure Storage Account Name" := NewAzureStorageAccountName;
                            "Azure Storage Account Key" := NewAzureStorageAccountKey;
                            "Azure Blob Container Name" := NewAzureBlobContainerName;
                            exit(Modify);
                        end;
                    end else
                        Error('');
                end;
        end;
    end;


    procedure AddFolderSlash(var FolderPath: Text[200])
    begin
        if FolderPath <> '' then
            if not (CopyStr(FolderPath, StrLen(FolderPath)) = '\') then
                FolderPath += '\';
    end;


    procedure SettlementMandatory(): Boolean
    begin
        exit("Settlement App. Area" = "Settlement App. Area"::Mandatory);
    end;


    procedure SettlementEnabled(): Boolean
    begin
        exit("Settlement App. Area" in ["Settlement App. Area"::Mandatory, "Settlement App. Area"::Optional]);
    end;


    procedure TestSettlementEnabled()
    begin
        if not SettlementEnabled then
            Error(SettlementsAreDisabled);
    end;


    procedure SetCompanyLogo()
    var
        TempFile: Record "CDC Temp File" temporary;
        FileInfo: Codeunit "CDC File Information";
        ImageManagement: Codeunit "CEM Image Management";
        OnlineSynchMgt: Codeunit "CEM Online Synch. Mgt.";
        VersionManagement: Codeunit "CSC Version Management";
        ReadStream: InStream;
        WriteStream: OutStream;
        FileName: Text[1024];
    begin
        CalcFields(Rec."Company Logo");
        if Rec."Company Logo".HasValue then
            if not Confirm(ConfirmReplaceCompanyLogo) then
                Error('');

        if UploadIntoStream('', '', '', FileName, ReadStream) then begin
            if (LowerCase(FileInfo.GetFileExtension(FileName)) <> 'png') then
                Error(ErrCompanyLogoFormat);

            if VersionManagement.NavVersion > 60010 then begin
                ImageManagement.FromStream(ReadStream);
                if (ImageManagement.GetHeight <> 60) or (ImageManagement.GetWidth <> 60) then
                    Error(ErrCompanyLogoSize);
            end;

            Rec."Company Logo".CreateOutStream(WriteStream);
            CopyStream(WriteStream, ReadStream);
            Rec.Modify;
            Commit;

            OnlineSynchMgt.SynchronizeSetup;
            Message(CompanyLogoUploaded);
        end;
    end;

    local procedure ConfigureToFromHomeFields()
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
    begin
        // This makes sure the Rec is not modified externally
        Rec."Force Field Update in CO" := true;
        Rec.Modify;

        if (Rec."Enable 60 day rule" or Rec."Deduct home-office distance") then begin
            ConfiguredFieldType.ConfigureFieldForTable(DATABASE::"CEM Mileage", FieldTypeCodeMgt.GetFromHomeCode, 0);
            ConfiguredFieldType.ConfigureFieldForTable(DATABASE::"CEM Mileage", FieldTypeCodeMgt.GetToHomeCode, 0);
        end else begin
            ConfiguredFieldType.UnConfigureFieldForTable(DATABASE::"CEM Mileage", FieldTypeCodeMgt.GetFromHomeCode, true);
            ConfiguredFieldType.UnConfigureFieldForTable(DATABASE::"CEM Mileage", FieldTypeCodeMgt.GetToHomeCode, true);
        end;
    end;


    procedure ReleaseNotAreScheduled(): Boolean
    begin
        exit(("Release Notification Method" = "Release Notification Method"::Scheduled) or
          ("Release Notification Method2" = "Release Notification Method2"::Scheduled));
    end;


    procedure CreateAndConfigureMultipleDest()
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
        EMCountryRegion: Record "CEM Country/Region";
        FieldType: Record "CEM Field Type";
        PerDiem: Record "CEM Per Diem";
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
    begin
        // This makes sure the Rec is not modified externally
        Rec."Force Field Update in CO" := true;
        Rec.Modify;

        FieldType.CreateFieldType(FieldTypeCodeMgt.GetPerDiemDepCountryCode, PerDiem.FieldCaption("Departure Country/Region"),
          FieldType.Type::Code, 10, true, DATABASE::"CEM Country/Region", EMCountryRegion.FieldNo(Code), EMCountryRegion.FieldNo(Name));
        ConfiguredFieldType.ConfigureFieldForTable(DATABASE::"CEM Per Diem", FieldTypeCodeMgt.GetPerDiemDepCountryCode, 10000);

        FieldType.CreateFieldType(FieldTypeCodeMgt.GetPerDiemDetDestCountryCode, PerDiem.FieldCaption("Destination Country/Region"),
          FieldType.Type::Code, 10, false, DATABASE::"CEM Country/Region", EMCountryRegion.FieldNo(Code), EMCountryRegion.FieldNo(Name));
        ConfiguredFieldType.ConfigureFieldForTable(DATABASE::"CEM Per Diem Detail", FieldTypeCodeMgt.GetPerDiemDetDestCountryCode, 10000);
    end;


    procedure DisableMultipleDestFields()
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
        EMCountryRegion: Record "CEM Country/Region";
        FieldType: Record "CEM Field Type";
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
    begin
        ConfiguredFieldType.UnConfigureFieldForTable(DATABASE::"CEM Per Diem", FieldTypeCodeMgt.GetPerDiemDepCountryCode, true);
        ConfiguredFieldType.UnConfigureFieldForTable(DATABASE::"CEM Per Diem", FieldTypeCodeMgt.GetPerDiemDetDestCountryCode, true);
    end;

    local procedure ConfigurePreApprovalFields()
    var
        ConfiguredFieldType: Record "CEM Configured Field Type";
        ExpenseHeader: Record "CEM Expense Header";
        FieldType: Record "CEM Field Type";
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
    begin
        // This makes sure the Rec is not modified externally
        Rec."Force Field Update in CO" := true;
        Rec.Modify;

        FieldType.CreateFieldType(FieldTypeCodeMgt.GetSettPreApprovalAmountCode, PreapprovalAmountCaption,
          FieldType.Type::Decimal, 20, true, 0, 0, 0);

        ConfiguredFieldType.SetSkipAllowedFieldCheck(true);

        if (Rec."Settlement Pre-approval" = Rec."Settlement Pre-approval"::Mandatory) or
           (Rec."Settlement Pre-approval" = Rec."Settlement Pre-approval"::Optional) then
            ConfiguredFieldType.ConfigureFieldForTable(DATABASE::"CEM Expense Header",
             FieldTypeCodeMgt.GetSettPreApprovalAmountCode, 0)
        else
            ConfiguredFieldType.UnConfigureFieldForTable(DATABASE::"CEM Expense Header",
             FieldTypeCodeMgt.GetSettPreApprovalAmountCode, true);
    end;
}

