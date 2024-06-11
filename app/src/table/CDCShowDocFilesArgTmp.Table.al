table 6085636 "CDC Show Doc. & Files Arg Tmp"
{
    Caption = 'Show Document and Files Arguments Temp';

    fields
    {
        field(1; "Document Category Code"; Code[10])
        {
            Caption = 'Document Category Code';
            NotBlank = true;
            TableRelation = "CDC Document Category";
        }
        field(2; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Files for OCR,Files for Import,Files with Error,Open Documents,Registered Documents,Rejected Documents,UIC Documents';
            OptionMembers = "Files for OCR","Files for Import","Files with Error","Open Documents","Registered Documents","Rejected Documents","UIC Documents";
        }
    }

    keys
    {
        key(Key1; "Document Category Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

