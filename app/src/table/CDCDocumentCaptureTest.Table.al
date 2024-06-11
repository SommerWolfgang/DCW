table 6085754 "CDC Document Capture Test"
{
    Caption = 'Document Capture Test';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'General Configuration,Connection to Document Capture Server,OCR-processing PDF files,Connection to email inboxes (IMAP),Purchase Approval Configuration,,,,,,Sending email from NAV (SMTP)';
            OptionMembers = GeneralConfiguration,ServiceIsRunning,ServiceProcessPDFFile,ServiceDownloadFromEmail,PurchApprovalSetup,,,,,,NAVSendEMail;
        }
        field(5; Result; Option)
        {
            Caption = 'Result';
            OptionCaption = ' ,Passed,Warning,Failed,Skipped';
            OptionMembers = " ",Passed,Warning,Failed,Skipped;
        }
        field(6; "Export Config. Files"; Boolean)
        {
            Caption = 'Export Configuration Files';
        }
        field(7; "Test PDF Filename"; Text[250])
        {
            Caption = 'Test PDF Filename';
        }
        field(8; "E-mail Address"; Text[80])
        {
            Caption = 'Email Address';
        }
        field(9; "No. of Messages"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("CDC Doc. Capture Test Message" where("Test Type" = field(Type)));
            Caption = 'No. of Messages';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

