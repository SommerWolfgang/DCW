table 6085784 "CDC Storage Migration Setup"
{
    Caption = 'Storage Migration Setup';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; "File Path for OCR-proc. files"; Text[200])
        {
            Caption = 'File Path for OCR-processed files';
        }
        field(7; "PDF File Path for OCR"; Text[200])
        {
            Caption = 'PDF File Path for OCR';
        }
        field(8; "Unidentified Company File Path"; Text[200])
        {
            Caption = 'Unidentified Company File Path';
        }
        field(11; "Archive File Path"; Text[200])
        {
            Caption = 'Archive File Path';
        }
        field(14; "Disk File Directory Structure"; Option)
        {
            Caption = 'Disk File Directory Structure';
            OptionCaption = 'One Directory,Year\Month,Year\Month\Day';
            OptionMembers = "One Directory","Year\Month","Year\Month\Day";
        }
        field(15; "Miscellaneous File Path"; Text[200])
        {
            Caption = 'Miscellaneous File Path';
        }
        field(23; "Document Storage Type"; Option)
        {
            Caption = 'Document Storage Type';
            OptionCaption = 'File System,Database,Azure Blob Storage';
            OptionMembers = "File System",Database,"Azure Blob Storage";
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
        }
        field(171; "Company Code in Archive"; Boolean)
        {
            Caption = 'Include Company Code in Archive paths';
        }
        field(174; "Category Code in Archive"; Boolean)
        {
            Caption = 'Include Category Code in Archive paths';
        }
        field(200; "XML File Path"; Text[200])
        {
            Caption = 'XML File Path';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if not AllDocumentsMigrated then
            Error(NotAllDocumentsMigratedErr, TableCaption);
    end;

    var
        NotAllDocumentsMigratedErr: Label 'Not all documents have been migrated to the new storage type. You must complete the migration before deleting the %1.';
        CurrentCompanyName: Text[30];

    local procedure AllDocumentsMigrated(): Boolean
    var
        Document: Record "CDC Document";
        DocumentUIC: Record "CDC Document (UIC)";
        DCSetup: Record "CDC Document Capture Setup";
    begin
        if CurrentCompanyName <> '' then begin
            DCSetup.ChangeCompany(CurrentCompanyName);
            Document.ChangeCompany(CurrentCompanyName);
        end;

        DCSetup.Get;
        Document.SetRange("Storage Migration Pending", true);
        DocumentUIC.SetRange("Storage Migration Pending", true);
        if DCSetup."Use UIC Documents" then
            exit(Document.IsEmpty and DocumentUIC.IsEmpty)
        else
            exit(Document.IsEmpty);
    end;


    procedure SetCurrentCompany(NewCompanyName: Text[30])
    begin
        ChangeCompany(NewCompanyName);
        CurrentCompanyName := NewCompanyName;
    end;
}

