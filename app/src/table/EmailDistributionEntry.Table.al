table 12032504 "Email Distribution Entry"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland

    Caption = 'Email Distribution Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Email Distribution Code"; Code[10])
        {
            Caption = 'Email Distribution Code';
            TableRelation = "Email Distribution Code".Code;
        }
        field(13; "Use for Type"; Option)
        {
            Caption = 'Use for Type';
            OptionCaption = ' ,Customer,Vendor,Contact,Responsibility Center';
            OptionMembers = " ",Customer,Vendor,Contact,"Responsibility Center";
        }
        field(14; "Use for Code"; Code[20])
        {
            Caption = 'Use for Code';
            TableRelation = if ("Use for Type" = const(Customer)) Customer
            else
            if ("Use for Type" = const(Vendor)) Vendor
            else
            if ("Use for Type" = const(Contact)) Contact
            else
            if ("Use for Type" = const("Responsibility Center")) "Responsibility Center";

            trigger OnValidate()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
            end;
        }
        field(18; "Distribution Type"; Option)
        {
            Caption = 'Distribution Type';
            OptionCaption = 'Email,PDF';
            OptionMembers = Mail,PDF,Fax;
        }
        field(40; "Sender Address"; Text[80])
        {
            Caption = 'Sender Address';
            ExtendedDatatype = EMail;
        }
        field(50; "Sender Name"; Text[80])
        {
            Caption = 'Sender Name';
        }
        field(70; "Recipient Address"; Text[80])
        {
            Caption = 'Recipient Address';
            ExtendedDatatype = EMail;
        }
        field(80; "Cc Recipients"; Text[250])
        {
            Caption = 'Cc Recipients';
            ExtendedDatatype = EMail;
        }
        field(90; "Subject Line"; Text[250])
        {
            Caption = 'Subject Line';
        }
        field(100; "Sending Date"; Date)
        {
            Caption = 'Sending Date';
        }
        field(110; "Sending Time"; Time)
        {
            Caption = 'Sending Time';
        }
        field(120; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(200; "Source Record ID"; RecordID)
        {
            Caption = 'Source Record ID';
        }
        field(300; "Return Message"; Text[250])
        {
            Caption = 'Rückmeldung';
        }
        field(1000; "Document No."; Code[20])
        {
            Description = '';
        }
        field(1001; "Document Type"; Text[80])
        {
            Description = '';
        }
        field(1003; "Document Date"; Date)
        {
            Description = '';
        }
        field(1005; "E-Mail"; Text[80])
        {
            Description = '';
        }
        field(1006; "Fax No."; Text[30])
        {
            Description = '';
        }
        field(1010; "Language Code"; Code[10])
        {
            Description = '';
        }
        field(1015; "Customer No."; Code[20])
        {
            Description = '';
        }
        field(1016; "Vendor No."; Code[20])
        {
            Description = '';
        }
        field(1017; "Contact No."; Code[20])
        {
            Description = '';
        }
        field(1018; "Resp. Center Code"; Code[20])
        {
            Description = '';
        }
        field(1020; "Item No."; Code[20])
        {
            Description = '';
        }
        field(1021; "Account No."; Code[20])
        {
            Description = '';
        }
        field(1022; "Transfer Code"; Code[20])
        {
            Description = '';
        }
        field(1050; "To Name"; Text[80])
        {
            Description = '';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

