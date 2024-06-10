table 6086236 "CTS-CDN Customer Setup"
{
    Caption = 'Customer Setup';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(210; "CDN Receiver Type"; Option)
        {
            Caption = 'Receiver Type';
            OptionCaption = 'VAT,GLN,Other';
            OptionMembers = VAT,GLN,Other;
        }
        field(211; "CDN Receiver ID Type"; Integer)
        {
            Caption = 'Receiver ID Type';
            TableRelation = "CTS-CDN Participation ID Type"."System ID";
        }
        field(212; "CDN Receiver ID Value"; Text[250])
        {
            Caption = 'Receiver ID';
        }
    }

    keys
    {
        key(Key1; "Customer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

