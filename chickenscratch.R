rails_map <- tm_shape(chiTracts) + tm_fill("numRailStp", pallette = "BuPu") + 
  tm_shape(railLines) + tm_lines()
illinois_map <- tm_shape(il_bounds) + tm_lines() +
  tm_shape(chiTracts) + tm_fill(col = 'red')

rails_map
print(illinois_map, vp = viewport(0.86, 0.27, width = 0.35, height = 0.5))

illinois_map

acs101 <- load_variables(2010, "acs1", cache = TRUE)
10 <- load_variables(2010, "sf1", cache = TRUE)
v117 <- load_variables(2017, "acs1", cache = TRUE)
c210 <- load_variables(2010, "sf2", cache = TRUE)
v317 <- load_variables(2017, "acs3", cache = TRUE)
sf32010 <- load_variables(2010, "sf3", cache = TRUE)
sf42000 <- load_variables(2010, "sf4", cache = TRUE)
sf12010 <- load_variables(2010, "sf1", cache = TRUE)
sf22010 <- load_variables(2010, "sf2", cache = TRUE)
View(acs101)
View(sf42000)
View(sf12010)
View(sf22010)

c_2000tenurebyrace <- get_decennial(
  geography = 'tract',
  variables = c(total = "H011001",
                tot_own = "H011002",
                whi_own = "H011003",
                bla_own = "H011004",
                aian_own = "H011005",
                asian_own = "H011006",
                nhpi_own = "H011007",
                oth_own = "H011008",
                oth2_own = "H011009",
                tot_rent = "H011010",
                whi_rent = "H011011",
                bla_rent = "H011012",
                aian_rent = "H011013",
                asian_rent = "H011014",
                nhpi_rent = "H011015",
                oth_rent = "H011016",
                oth2_rent = "H011017"),
  year = 2000, state = 'IL', county = 'Cook', geometry = FALSE
)
write.csv(c_2000tenurebyrace, "/Users/zackwoods01/Desktop/gisFinal/c_2000tenurebyrace.csv")

c2010 <- get_decennial(
  geography = 'zcta',
  variables = c(tot_own = "H014002",
                total = "H014001",
                whi_own = "H014003",
                bla_own = "H014004",
                tot_rent = "H014010",
                whi_rent = "H014011",
                bla_rent = "H014012"),
  year = 2010, geometry = FALSE
) %>% 
  select(GEOID, NAME, variable, value) %>% 
  spread(variable, value) %>% 
  mutate(propown = tot_own/total, propwown = whi_own/total, propbown = bla_own/total, proprent = tot_rent/total,
         propwrent = whi_rent/total, propbrent = bla_rent/total)  %>%
  select(GEOID,propown, propwown, propbown, proprent, propwrent, propbrent)
  
write.csv(c2010, "/Users/zackwoods01/Desktop/gisFinal/census2010rentown.csv")

View(c_2000tenurebyrace)
View(total)
View(v17)
View(c10)
View(c210)
View(v06)

acs17_pttowork <- get_acs(geography = "tract", variables = "B08006_008", year = 2017, state = 'IL')
View(acs17_atleast1car)
str(acs17_atleast1car)
write.csv(acs17_pttowork, file = "pttowork.csv")
acs17_1car <- st_as_sf(acs17_atleast1car)

cta <- read_gtfs("https://www.transitchicago.com/downloads/sch_data/google_transit.zip")
summary(cta)
