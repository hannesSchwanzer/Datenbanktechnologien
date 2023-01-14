# F¨ugen Sie zur Relation Auftragsposten das Attribut Einzelpreis hinzu. F¨ullen
# Sie dieses Attribut mit Daten auf, ermittelt aus den Attributen Anzahl und Gesamtpreis.
ALTER TABLE auftragsposten ADD Einzelpreis FLOAT;
UPDATE auftragsposten SET Einzelpreis = Gesamtpreis / Anzahl;
SELECT * FROM auftragsposten;


# Erzeugen Sie in der Beispieldatenbank Bike eine Sicht VPers, die der Relation Personal ohne die Attribute Gehalt und Beurteilung entspricht. Weiter sind in
# dieser Sicht nur die Personen aufzunehmen, denen ein Vorgesetzter zugeordnet ist. Liegt
# eine ¨anderbare Sicht vor? Begr¨unden Sie ihre Antwort.
CREATE VIEW VPers (Persnr, NAME, Strasse, PLZ, Ort, GebDatum, Stand, Vorgesetzt, Aufgabe) AS
(SELECT Persnr, NAME, Strasse, PLZ, Ort, GebDatum, Stand, Vorgesetzt, Aufgabe from personal WHERE Vorgesetzt IS NOT NULL);
SELECT * FROM Vpers;
# Ist editierbar. Gründe: Primary Key aus der Tabelle, mit welcher die View erstellt wurde existiert noch. Es gibt keine Felder die aus Aggregatsfunktionen
# bestehen. Es gibt keine Distinct Klauseln, Subqueries, GROUP BY oder HAVING. Basiert auf keiner anderen View. Es gibt keine Konstanten.



# Die Relation Auftragsposten enth¨alt aus Redundanzgr¨unden nur den Gesamtpreis jedes einzelnen Auftragspostens. Schreiben Sie daher eine Sicht VAuftragsposten,
# die alle Daten der Relation Auftragsposten enth¨alt und zus¨atzlich ein Attribut Einzelpreis. Ist diese Sicht ¨anderbar? Begr¨unden Sie ihre Antwort.
CREATE VIEW VAutragsposten(PosNr, AuftrNr, Artnr, Anzahl, Gesamtpreis, Einzelpreis) AS
(SELECT PosNr, AuftrNr, Artnr, Anzahl, Gesamtpreis, Gesamtpreis / Anzahl FROM auftragsposten);
# NICHT EDITIERBAR WEIL - muss noch schreiben lmeo


# Beim Einf¨ugen und Andern von Artikeln soll automatisch aus dem Netto- ¨
# preis die Mehrwertsteuer (19%) und der Gesamtpreis ermittelt werden. Schreiben Sie
# einen geeigneten Trigger. Testen Sie den Trigger.
CREATE OR REPLACE TRIGGER GesamtPreisErmittlungInsert 
BEFORE INSERT ON artikel
FOR EACH ROW 
SET NEW.Steuer = (NEW.Netto * 0.19), NEW.Preis = (NEW.Netto + (NEW.NETTO *0.19));

CREATE OR REPLACE TRIGGER GesamtPreisErmittlungUpdate
BEFORE UPDATE ON artikel
FOR EACH ROW 
SET NEW.Steuer = (NEW.Netto * 0.19), NEW.Preis = (NEW.Netto + (NEW.NETTO *0.19));


# Alle neuen Kunden sollen automatisch mit einer Kundennummer versehen
# werden. Diese Nummern beginnen bei 21. Es sollen nur ungeradzahlige Kundennummern vergeben werden. 
# Schreiben Sie eine geeignete Sequenz. Probieren Sie diese Sequenz durch Hinzuf¨ugen von neuen Kunden aus.
CREATE OR REPLACE SEQUENCE KnSq START WITH 21 INCREMENT BY 2;
INSERT INTO kunde(Nr, NAME, Strasse, PLZ, Ort, Sperre) VALUES (NEXT VALUE FOR KnSq, "heheheha", "lmaostraße 3", 92321, "Grrrbach", 0);

# In MySQL gibt es die Spaltenbedingung AutoIncrement. Damit erh¨alt dieses
# Attribut immer eine eindeutige automatische Nummer. Bilden Sie diese Funktion mittels
# Sequenzen und Trigger f¨ur das Attribut Persnr der Relation Personal nach.
CREATE OR REPLACE SEQUENCE AIRepl START WITH 10;

CREATE OR REPLACE TRIGGER AIReplTrig
BEFORE INSERT ON personal
FOR EACH ROW
SET NEW.PersNr = NEXT VALUE FOR AIRepl;

INSERT INTO personal	(NAME, Strasse, PLZ, Ort, GebDatum, Stand, Vorgesetzt, Gehalt, Beurteilung, Aufgabe) 
				VALUES 	("grrr", "heheheha", 92831, "hohohoi", "1979-07-05", "verh", 3, 2300, 3, "lmaolord");
				
# Schreiben Sie einen Befehl, der dem Benutzer Gast Anderungsrechte auf die ¨
# Attribute Bestand, Reserviert und Bestellt der Relation Lager und Leserechte auf die
# gesamte Relation einr¨aumt
GRANT UPDATE (Bestand, Reserviert, Bestellt) 
ON lager
TO 'Gast'@'localhost';

# Entziehen Sie dem Benutzer Gast die in der vorherigen Aufgabe gew¨ahrten Rechte wieder
REVOKE UPDATE (Bestand, Reserviert, Bestellt)
ON lager
FROM 'Gast'@'localhost';


#Schreiben Sie alle notwendigen Befehle, damit der Benutzer Gast nur Leserechte
#auf die Attribute Artnr, Lagerort und Bestand der Relation Lager bekommt. Weiter darf
#er Tupel dieser Relation nicht sehen, falls Mindestbestand plus reservierte Teile gr¨oßer
#als der tats¨achliche Bestand ist. Diese Rechte darf der Benutzer Gast auch weiterreichen.
CREATE USER Gast;
CREATE VIEW VPermission(Artnr, Lagerort, Bestand) AS
	(SELECT Artnr, Lagerort, Bestand FROM lager 
		WHERE (lager.Mindbest + lager.Reserviert) <= lager.Bestand); 
GRANT SELECT ON vpermission TO Gast WITH GRANT OPTION;

EXECUTE AS USER = 'Gast';
SELECT * FROM vpermission;


#Um die Integrit¨at zu optimieren, sollen die Attribute GebDatum, Stand,
#Gehalt und Beurteilung der Relation Personal auf zul¨assige Werte ¨uberpr¨uft werden. Es
#ist bekannt, dass alle Mitarbeiter zwischen 1940 und 1998 geboren sind, entweder ledig,
#verheiratet, geschieden oder verwitwet sind, das Gehalt zwischen 500 und 6000 Euro liegt
#und die Beurteilung entweder Null oder einen Wert zwischen 1 und 10 besitzt. F¨ugen
#Sie diese Bedingungen mittels geeigneter Alter-Table-Befehle hinzu, wobei sicherzustellen
#ist, dass diese Bedingungen, falls gew¨unscht, auch wieder entfernt werden k¨onnen (bitte
#Constraintnamen vergeben!).


ALTER TABLE personal ADD CONSTRAINT zulaessig CHECK (
	(GebDatum >= STR_TO_DATE('1940-01-01', '%Y-%m-%d') && GebDatum <= STR_TO_DATE('1998-12-31', '%Y-%m-%d'))
	&& (Stand LIKE 'led' || Stand LIKE 'verh' || Stand LIKE 'ges' || Stand LIKE 'verw')
	&& (Gehalt > 500 && Gehalt < 6000)
	&& (Beurteilung IS NULL || (Beurteilung >= 1 && Beurteilung <= 10))
	);


#Tests
INSERT INTO personal(Persnr, NAME, GebDatum) VALUE (11, 'test', "1901-03-11");
INSERT INTO personal(Persnr, NAME, GebDatum, Stand) VALUE (11, 'test', "1945-03-11", 't');
INSERT INTO personal(Persnr, NAME, GebDatum, Gehalt) VALUE (11, 'test', "1945-03-11", 300);
INSERT INTO personal(Persnr, NAME, GebDatum, Beurteilung) VALUE (11, 'test', "1945-03-11", 11);


# Im Attribut Aufgabe der Relation Personal gibt es nur eine beschr¨ankte
# Anzahl von m¨oglichen Aufgaben. Definieren Sie ein Gebiet Berufsbezeichnung, das eine
# Ansammlung von m¨oglichen Berufen enth¨alt.
Alter Table personal add column ENUM('Manager', 'Vertreter', 'Facharbeiterin', 'Sekretr', 'Meister', 'Arbeiter', 'Sachabearbeiterin', 'Azubi');





