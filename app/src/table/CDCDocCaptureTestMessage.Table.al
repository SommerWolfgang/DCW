table 6085755 "CDC Doc. Capture Test Message"
{
    Caption = 'Document Capture Test Message';

    fields
    {
        field(1; "Test Type"; Option)
        {
            Caption = 'Test Type';
            OptionCaption = 'General Configuration,Connection to Document Capture Server,OCR-processing PDF files,Connection to email inboxes (IMAP),Purchase Approval Configuration,,,,,,Sending email from NAV (SMTP)';
            OptionMembers = GeneralConfiguration,ServiceIsRunning,ServiceProcessPDFFile,ServiceDownloadFromEmail,PurchApprovalSetup,,,,,,NAVSendEMail;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; Message; Text[250])
        {
            Caption = 'Message';
        }
        field(4; "Created At"; DateTime)
        {
            Caption = 'Created At';
        }
    }

    keys
    {
        key(Key1; "Test Type", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        TestMessage: Record "CDC Doc. Capture Test Message";
    begin
        TestMessage.SetRange("Test Type", "Test Type");
        if TestMessage.FindLast() then
            "Entry No." := TestMessage."Entry No." + 1
        else
            "Entry No." := 1;

        "Created At" := CurrentDateTime;
    end;
}

