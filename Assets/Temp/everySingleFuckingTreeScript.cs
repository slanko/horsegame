using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class everySingleFuckingTreeScript : MonoBehaviour
{
    //thanks to BlakeGillman on the unity forums for this script we then proceeded to hack to pieces

    public GameObject theTree;
    public TerrainData[] myTerrains;
    public GameObject[] actualTerrains;

    // Use this for initialization
    void Start()
    {
        for(int i = 0; i < myTerrains.Length; i++)
        {
            var currentTerrain = myTerrains[i];
            // For every tree on the island
            foreach (TreeInstance tree in currentTerrain.treeInstances)
            {
                // Find its local position scaled by the terrain size (to find the real world position)
                Vector3 worldTreePos = Vector3.Scale(tree.position, currentTerrain.size) + actualTerrains[i].transform.position;
                Instantiate(theTree, worldTreePos, Quaternion.identity); // Create a prefab tree on its pos
                

            }


            /*
            // Then delete all trees on the island
            List<TreeInstance> newTrees = new List<TreeInstance>(0);
            theIsland.treeInstances = newTrees.ToArray();
            */
        }

    }
}
