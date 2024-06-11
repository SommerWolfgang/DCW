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
        }
        field(21; "Archive Path"; Text[250])
        {
            Caption = 'Archive Path';
        }
        field(22; "Company Code in Archive"; Boolean)
        {
            Caption = 'Company Code in Archive';
        }
        field(24; "Document Storage Type"; Option)
        {
            Caption = 'Document Storage Type';
            OptionCaption = 'File System,Database,Azure Blob Storage';
            OptionMembers = "File System",Database,"Azure Blob Storage";
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
        }
        field(115; "Card Transaction Bal. No."; Code[20])
        {
            Caption = 'Bal. Account No.';
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
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get() then begin
                                EMSetup."Dynamics NAV Server Tenant" := "Dynamics NAV Server Tenant";
                                EMSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(154; "Dynamics NAV Server Name"; Text[50])
        {
            Caption = 'Dynamics NAV Server Name';
        }
        field(155; "Dynamics NAV Server Instance"; Text[50])
        {
            Caption = 'Dynamics NAV Server Instance';
        }
        field(156; "Dynamics NAV Server Port"; Integer)
        {
            Caption = 'Dynamics NAV Server Port';
        }
        field(157; "Dynamics NAV Web Server Name"; Text[50])
        {
            Caption = 'Dynamics NAV Web Server Name';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                Company: Record Company;
            begin
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get() then begin
                                EMSetup."Dynamics NAV Web Server Name" := "Dynamics NAV Web Server Name";
                                EMSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
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
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get() then begin
                                EMSetup."Dynamics NAV Web Server Port" := "Dynamics NAV Web Server Port";
                                EMSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
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
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get() then begin
                                EMSetup."Dynamics NAV Web Server Inst." := "Dynamics NAV Web Server Inst.";
                                EMSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
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
                if Company.FindSet() then
                    repeat
                        if Company.Name <> CompanyName then begin
                            EMSetup.ChangeCompany(Company.Name);
                            if EMSetup.Get() then begin
                                EMSetup."Dynamics NAV Web Server Tenant" := "Dynamics NAV Web Server Tenant";
                                EMSetup.Modify();
                            end;
                        end;
                    until Company.Next() = 0;

                Modify();
            end;
        }
        field(161; "Dynamics NAV Web Server SSL"; Boolean)
        {
            Caption = 'Use Dynamics NAV Web Server With SSL';
        }
        field(201; "Expense Template Name"; Code[10])
        {
            Caption = 'Expense Template Name';
            TableRelation = "Gen. Journal Template" where(Type = const(General));
        }
        field(251; "Expense Batch Name"; Code[10])
        {
            Caption = 'Expense Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Expense Template Name"));
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
        }
        field(301; "Shortcut Field 2 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
        }
        field(302; "Shortcut Field 3 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
        }
        field(303; "Shortcut Field 4 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
        }
        field(304; "Shortcut Field 5 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
        }
        field(305; "Shortcut Field 6 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
        }
        field(306; "Shortcut Field 7 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
        }
        field(307; "Shortcut Field 8 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
        }
        field(308; "Shortcut Field 9 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
        }
        field(309; "Shortcut Field 10 Code (Exp.)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
        }
        field(310; "Data Version"; Integer)
        {
            Caption = 'Data Version';
        }
        field(320; "Shortcut Field 1 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
        }
        field(321; "Shortcut Field 2 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
        }
        field(322; "Shortcut Field 3 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
        }
        field(323; "Shortcut Field 4 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
        }
        field(324; "Shortcut Field 5 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
        }
        field(325; "Shortcut Field 6 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
        }
        field(326; "Shortcut Field 7 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
        }
        field(327; "Shortcut Field 8 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
        }
        field(328; "Shortcut Field 9 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
        }
        field(329; "Shortcut Field 10 Code (App.)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
        }
        field(340; "Distance Unit"; Option)
        {
            Caption = 'Distance Unit';
            OptionCaption = 'Km,Miles';
            OptionMembers = Km,Miles;
        }
        field(350; "Mileage Posting Description"; Text[30])
        {
            Caption = 'Mileage Posting Description';
        }
        field(359; "Deduct home-office distance"; Boolean)
        {
            Caption = 'Deduct distance between home and office';
        }
        field(360; "Enable 60 day rule"; Boolean)
        {
            Caption = 'Enable 60 day rule check';
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
        }
        field(371; "Shortcut Field 1 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
        }
        field(372; "Shortcut Field 2 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
        }
        field(373; "Shortcut Field 3 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
        }
        field(374; "Shortcut Field 4 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
        }
        field(375; "Shortcut Field 5 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
        }
        field(376; "Shortcut Field 6 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
        }
        field(377; "Shortcut Field 7 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
        }
        field(378; "Shortcut Field 8 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
        }
        field(379; "Shortcut Field 9 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
        }
        field(380; "Shortcut Field 10 Code (Mil.)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
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
        }
        field(390; "Enable Settlement"; Boolean)
        {
            Caption = 'Enable Settlement';
        }
        field(391; "Enable Per Diem"; Boolean)
        {
            Caption = 'Enable Per Diem';
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
        }
        field(396; "Per Diem Posting Description"; Text[30])
        {
            Caption = 'Per Diem Posting Description';
        }
        field(397; "Calc. mil. across companies"; Boolean)
        {
            Caption = 'Calculate mileage across companies';
        }
        field(400; "Re-Get Transactions"; Boolean)
        {
            Caption = 'Re-Get Transactions';
        }
        field(401; "Shortcut Field 1 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
        }
        field(402; "Shortcut Field 2 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
        }
        field(403; "Shortcut Field 3 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
        }
        field(404; "Shortcut Field 4 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
        }
        field(405; "Shortcut Field 5 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
        }
        field(406; "Shortcut Field 6 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
        }
        field(407; "Shortcut Field 7 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
        }
        field(408; "Shortcut Field 8 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
        }
        field(409; "Shortcut Field 9 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
        }
        field(410; "Shortcut Field 10 Code (Sttl.)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
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
        }
        field(420; "Short. Fld. 1 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 1 Code';
        }
        field(421; "Short. Fld. 2 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 2 Code';
        }
        field(422; "Short. Fld. 3 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 3 Code';
        }
        field(423; "Short. Fld. 4 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 4 Code';
        }
        field(424; "Short. Fld. 5 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 5 Code';
        }
        field(425; "Short. Fld. 6 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 6 Code';
        }
        field(426; "Short. Fld. 7 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 7 Code';
        }
        field(427; "Short. Fld. 8 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 8 Code';
        }
        field(428; "Short. Fld. 9 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 9 Code';
        }
        field(429; "Short. Fld. 10 Code (Per Diem)"; Code[20])
        {
            Caption = 'Shortcut Field 10 Code';
        }
        field(430; "Use Entertainment Allowance"; Boolean)
        {
            Caption = 'Enable allowance for entertainment';
        }
        field(431; "Use Drinks Allowance"; Boolean)
        {
            Caption = 'Enable allowance for drinks';
        }
        field(432; "Use Transport Allowance"; Boolean)
        {
            Caption = 'Enable allowance for transportation';
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
        }
        field(435; "Enable Per Diem Destinations"; Boolean)
        {
            Caption = 'Enable multiple destinations';
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
    procedure LookupLessorJournalName(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;

    procedure MoveDocFilesToNewStorageSetup2(EMSetup: Record "CEM Expense Management Setup"; xEMSetup: Record "CEM Expense Management Setup")
    var
        ContCompSetup: Record "CDC Continia Company Setup";
    begin
        ContCompSetup.Get();
    end;

    procedure PromptAndSendTestMail()
    begin
    end;

    procedure IsFilePathUniqueCrossComp(FilePath: Text[200])
    begin
    end;

    procedure VerifyFilePathsCrossComp()
    begin
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
    begin
    end;

    procedure AddFolderSlash(var FolderPath: Text[200])
    begin
        if FolderPath <> '' then
            if not (CopyStr(FolderPath, StrLen(FolderPath)) = '\') then
                FolderPath += '\';
    end;


    procedure SettlementMandatory(): Boolean
    begin
    end;

    procedure SettlementEnabled(): Boolean
    begin
    end;

    procedure TestSettlementEnabled()
    begin
    end;

    procedure SetCompanyLogo()
    begin
    end;

    procedure ReleaseNotAreScheduled(): Boolean
    begin
    end;

    procedure CreateAndConfigureMultipleDest()
    begin
    end;

    procedure DisableMultipleDestFields()
    begin
    end;
}