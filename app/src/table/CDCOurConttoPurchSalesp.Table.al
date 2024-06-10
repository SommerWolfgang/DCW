table 6085778 "CDC Our Cont. to Purch./Salesp"
{
    Caption = 'Our Contact to Purchaser/Salesperson';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
        }
        field(2; "Vendor/Customer No."; Code[20])
        {
            Caption = 'Vendor/Customer No.';
            TableRelation = IF (Type = CONST(Vendor)) Vendor
            ELSE
            IF (Type = CONST(Customer)) Customer;
        }
        field(3; "Our Contact"; Code[200])
        {
            Caption = 'Our Contact';
            NotBlank = true;
        }
        field(4; "Salespers./Purch. Code"; Code[20])
        {
            Caption = 'Salesperson/Purchaser Code';
            NotBlank = true;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    keys
    {
        key(Key1; Type, "Vendor/Customer No.", "Our Contact")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Salespers./Purch. Code");
    end;


    procedure GetName(): Text[100]
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        if Type = Type::Vendor then begin
            if Vendor.Get("Vendor/Customer No.") then
                exit(Vendor.Name);
        end else begin
            if Customer.Get("Vendor/Customer No.") then
                exit(Customer.Name);
        end;
    end;
}

